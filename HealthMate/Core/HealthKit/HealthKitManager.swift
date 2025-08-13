//
//  HealthKitManager.swift
//  HealthMate
//

import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()

    private init() {}

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        ]

        try await healthStore.requestAuthorization(toShare: nil, read: readTypes)
    }

    func fetchTodayStepCount() async throws -> Double {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDayLocal, end: Date().endOfDayLocal)
        let sum = try await statisticsSum(for: stepType, predicate: predicate)
        return sum?.doubleValue(for: HKUnit.count()) ?? 0
    }

    func fetchTodayActiveEnergyBurned() async throws -> Double {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDayLocal, end: Date().endOfDayLocal)
        let sum = try await statisticsSum(for: energyType, predicate: predicate)
        return sum?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
    }

    func fetchProfile() async throws -> (age: Int?, sex: BiologicalSex?, heightCm: Double?, weightKg: Double?) {
        var ageYears: Int?
        if let dob = try? healthStore.dateOfBirthComponents().date {
            let years = Calendar.app.dateComponents([.year], from: dob, to: Date()).year
            ageYears = years
        }

        var sexValue: BiologicalSex?
        if let sex = try? healthStore.biologicalSex().biologicalSex {
            switch sex {
            case .male: sexValue = .male
            case .female: sexValue = .female
            default: break
            }
        }

        async let height = latestQuantitySample(.height, unit: HKUnit.meter())
        async let weight = latestQuantitySample(.bodyMass, unit: HKUnit.gramUnit(with: .kilo))

        let heightM = try await height
        let weightKg = try await weight

        let heightCm = heightM.map { $0 * 100.0 }

        return (ageYears, sexValue, heightCm, weightKg)
    }

    private func statisticsSum(for type: HKQuantityType, predicate: NSPredicate) async throws -> HKQuantity? {
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, error in
                if let error { continuation.resume(throwing: error); return }
                continuation.resume(returning: stats?.sumQuantity())
            }
            healthStore.execute(query)
        }
    }

    private func latestQuantitySample(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double? {
        let type = HKQuantityType.quantityType(forIdentifier: identifier)!
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, error in
                if let error { continuation.resume(throwing: error); return }
                guard let quantitySample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }
                let value = quantitySample.quantity.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }
}



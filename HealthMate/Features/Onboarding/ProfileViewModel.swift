//
//  ProfileViewModel.swift
//  HealthMate
//

import Foundation
import CoreData

final class ProfileViewModel: ObservableObject {
    @Published var age: Int = 25
    @Published var sex: BiologicalSex = .male
    @Published var heightCm: Double = 175
    @Published var weightKg: Double = 70
    @Published var activity: ActivityLevel = .moderate
    @Published var goal: Goal = .maintain

    @Published var bmr: Double = 0
    @Published var tdee: Double = 0
    @Published var bmi: Double = 0

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        recalc()
    }

    func recalc() {
        bmr = Calculators.calculateBMR(weightKg: weightKg, heightCm: heightCm, ageYears: age, sex: sex)
        tdee = Calculators.calculateTDEE(bmr: bmr, activityLevel: activity)
        bmi = Calculators.calculateBMI(weightKg: weightKg, heightCm: heightCm)
    }
}



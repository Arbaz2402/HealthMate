//
//  DashboardViewModel.swift
//  HealthMate
//

import Foundation
import CoreData

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var stepsToday: Int = 0
    @Published var activeEnergyToday: Double = 0
    @Published var caloriesConsumedToday: Double = 0

    @Published var bmr: Double = 0
    @Published var totalBurnedToday: Double = 0
    @Published var netCaloriesToday: Double = 0

    private let viewContext: NSManagedObjectContext

    // Simplified in-memory profile; later bind to Core Data profile.
    var profileAge: Int = 25
    var profileSex: BiologicalSex = .male
    var profileHeightCm: Double = 175
    var profileWeightKg: Double = 70

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func refresh() async {
        do {
            async let steps = HealthKitManager.shared.fetchTodayStepCount()
            async let active = HealthKitManager.shared.fetchTodayActiveEnergyBurned()
            let (stepsVal, activeVal) = try await (steps, active)

            stepsToday = Int(stepsVal)
            activeEnergyToday = activeVal

            // Compute BMR and totals
            bmr = Calculators.calculateBMR(
                weightKg: profileWeightKg,
                heightCm: profileHeightCm,
                ageYears: profileAge,
                sex: profileSex
            )

            // Update calories consumed from Core Data (today)
            caloriesConsumedToday = fetchCaloriesConsumedToday()

            let activeEnergy = activeEnergyToday > 0 ? activeEnergyToday : Calculators.estimateActiveCaloriesFromSteps(steps: stepsToday, weightKg: profileWeightKg)
            totalBurnedToday = bmr + activeEnergy
            netCaloriesToday = caloriesConsumedToday - totalBurnedToday
        } catch {
            // Keep values as-is on error
        }
    }

    private func fetchCaloriesConsumedToday() -> Double {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodEntry")
        request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", Date().startOfDayLocal as NSDate, Date().endOfDayLocal as NSDate)

        let expression = NSExpressionDescription()
        expression.name = "sumCalories"
        expression.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "calories")])
        expression.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = [expression]
        request.resultType = .dictionaryResultType

        do {
            if let result = try viewContext.fetch(request).first as? [String: Any], let sum = result["sumCalories"] as? Double {
                return sum
            }
        } catch {}
        return 0
    }
}



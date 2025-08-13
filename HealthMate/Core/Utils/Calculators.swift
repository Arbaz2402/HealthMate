//
//  Calculators.swift
//  HealthMate
//
//  Provides health-related calculations: BMR, TDEE, BMI, and macro targets.
//

import Foundation

enum BiologicalSex: Int16 {
    case male = 0
    case female = 1
}

enum ActivityLevel: Int16, CaseIterable {
    case sedentary = 0
    case light
    case moderate
    case veryActive
    case athlete

    var factor: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .veryActive: return 1.725
        case .athlete: return 1.9
        }
    }
}

enum Goal: Int16 {
    case lose = 0
    case maintain = 1
    case gain = 2
}

struct MacroTargets {
    let caloriesTarget: Double
    let proteinGrams: Double
    let carbsGrams: Double
    let fatGrams: Double
}

struct Calculators {
    static func calculateBMR(weightKg: Double, heightCm: Double, ageYears: Int, sex: BiologicalSex) -> Double {
        switch sex {
        case .male:
            return 10.0 * weightKg + 6.25 * heightCm - 5.0 * Double(ageYears) + 5.0
        case .female:
            return 10.0 * weightKg + 6.25 * heightCm - 5.0 * Double(ageYears) - 161.0
        }
    }

    static func calculateTDEE(bmr: Double, activityLevel: ActivityLevel) -> Double {
        return bmr * activityLevel.factor
    }

    static func calculateBMI(weightKg: Double, heightCm: Double) -> Double {
        let heightM = heightCm / 100.0
        guard heightM > 0 else { return 0 }
        return weightKg / (heightM * heightM)
    }

    // Simple macro split defaults: Protein 30%, Carbs 40%, Fat 30%
    static func calculateMacroTargets(calorieTarget: Double, proteinRatio: Double = 0.30, carbRatio: Double = 0.40, fatRatio: Double = 0.30) -> MacroTargets {
        let proteinCalories = calorieTarget * proteinRatio
        let carbCalories = calorieTarget * carbRatio
        let fatCalories = calorieTarget * fatRatio

        // 1g protein = 4 kcal, 1g carbs = 4 kcal, 1g fat = 9 kcal
        return MacroTargets(
            caloriesTarget: calorieTarget,
            proteinGrams: proteinCalories / 4.0,
            carbsGrams: carbCalories / 4.0,
            fatGrams: fatCalories / 9.0
        )
    }

    // Fallback active energy estimation from steps
    // If duration unknown, use approx kcal/step scaled by body weight.
    // Base constant: 0.045 kcal/step for 70kg, scale linearly by (weightKg/70).
    static func estimateActiveCaloriesFromSteps(steps: Int, weightKg: Double) -> Double {
        let baseCaloriesPerStepAt70kg = 0.045
        let scaledCaloriesPerStep = baseCaloriesPerStepAt70kg * (weightKg / 70.0)
        return Double(steps) * scaledCaloriesPerStep
    }
}



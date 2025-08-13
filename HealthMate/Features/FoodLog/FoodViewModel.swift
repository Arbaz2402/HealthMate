//
//  FoodViewModel.swift
//  HealthMate
//

import Foundation
import CoreData

final class FoodViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var calories: Double = 0
    @Published var protein: Double = 0
    @Published var carbs: Double = 0
    @Published var fat: Double = 0
    @Published var mealType: String = "Other"

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addFood() {
        let entry = FoodEntry(context: viewContext)
        entry.id = UUID()
        entry.timestamp = Date()
        entry.name = name
        entry.calories = calories
        entry.protein = protein
        entry.carbs = carbs
        entry.fat = fat
        entry.mealType = mealType
        do { try viewContext.save() } catch {}
    }
}



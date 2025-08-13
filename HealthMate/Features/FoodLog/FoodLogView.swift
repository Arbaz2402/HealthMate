//
//  FoodLogView.swift
//  HealthMate
//

import SwiftUI
import CoreData

struct FoodLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isPresentingAdd = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.timestamp, ascending: false)],
        predicate: NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", Date().startOfDayLocal as NSDate, Date().endOfDayLocal as NSDate),
        animation: .default)
    private var foods: FetchedResults<FoodEntry>

    private var totalCalories: Double { foods.reduce(0) { $0 + $1.calories } }

    var body: some View {
        List {
            Section(header: Text("Today"), footer: Text("Total: \(Int(totalCalories)) kcal")) {
                ForEach(foods) { food in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(food.name ?? "Food")
                            Text(food.mealType ?? "").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(Int(food.calories)) kcal")
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Food Log")
        .toolbar {
            ToolbarItem(placement: .primaryAction) { Button(action: { isPresentingAdd = true }) { Image(systemName: "plus") } }
        }
        .sheet(isPresented: $isPresentingAdd) { AddFoodView() }
    }

    private func delete(at offsets: IndexSet) {
        offsets.map { foods[$0] }.forEach(viewContext.delete)
        try? viewContext.save()
    }
}



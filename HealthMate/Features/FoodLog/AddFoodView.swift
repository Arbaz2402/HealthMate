//
//  AddFoodView.swift
//  HealthMate
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: FoodViewModel
    @Environment(\.dismiss) private var dismiss

    init() {
        _viewModel = StateObject(wrappedValue: FoodViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $viewModel.name)
                HStack {
                    Text("Calories")
                    Spacer()
                    TextField("kcal", value: $viewModel.calories, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                HStack {
                    Text("Protein (g)")
                    Spacer()
                    TextField("g", value: $viewModel.protein, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                HStack {
                    Text("Carbs (g)")
                    Spacer()
                    TextField("g", value: $viewModel.carbs, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                HStack {
                    Text("Fat (g)")
                    Spacer()
                    TextField("g", value: $viewModel.fat, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                TextField("Meal type", text: $viewModel.mealType)
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.addFood(); dismiss() }
                        .disabled(viewModel.name.isEmpty || viewModel.calories <= 0)
                }
            }
        }
    }
}



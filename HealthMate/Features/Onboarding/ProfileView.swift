//
//  ProfileView.swift
//  HealthMate
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProfileViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        Form {
            Section("Profile") {
                Stepper(value: $viewModel.age, in: 10...100) {
                    HStack { Text("Age"); Spacer(); Text("\(viewModel.age)") }
                }
                Picker("Sex", selection: $viewModel.sex) {
                    Text("Male").tag(BiologicalSex.male)
                    Text("Female").tag(BiologicalSex.female)
                }.pickerStyle(.segmented)
                HStack {
                    Text("Height (cm)")
                    Spacer()
                    TextField("cm", value: $viewModel.heightCm, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                HStack {
                    Text("Weight (kg)")
                    Spacer()
                    TextField("kg", value: $viewModel.weightKg, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                Picker("Activity", selection: $viewModel.activity) {
                    Text("Sedentary").tag(ActivityLevel.sedentary)
                    Text("Light").tag(ActivityLevel.light)
                    Text("Moderate").tag(ActivityLevel.moderate)
                    Text("Very Active").tag(ActivityLevel.veryActive)
                    Text("Athlete").tag(ActivityLevel.athlete)
                }
                Picker("Goal", selection: $viewModel.goal) {
                    Text("Lose").tag(Goal.lose)
                    Text("Maintain").tag(Goal.maintain)
                    Text("Gain").tag(Goal.gain)
                }
            }

            Section("Auto-calculated") {
                LabeledContent("BMR") { Text("\(Int(viewModel.bmr)) kcal") }
                LabeledContent("TDEE") { Text("\(Int(viewModel.tdee)) kcal") }
                LabeledContent("BMI") { Text(String(format: "%.1f", viewModel.bmi)) }
            }
        }
        .onChange(of: viewModel.age) { _ in viewModel.recalc() }
        .onChange(of: viewModel.sex) { _ in viewModel.recalc() }
        .onChange(of: viewModel.heightCm) { _ in viewModel.recalc() }
        .onChange(of: viewModel.weightKg) { _ in viewModel.recalc() }
        .onChange(of: viewModel.activity) { _ in viewModel.recalc() }
        .navigationTitle("Profile")
    }
}



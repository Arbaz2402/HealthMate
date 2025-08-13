//
//  SettingsView.swift
//  HealthMate
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: SettingsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        Form {
            Section("Formulas") {
                Toggle("Use Mifflin–St Jeor", isOn: $viewModel.useMifflinStJeor)
            }
            Section("Units") {
                Toggle("Metric (kg/cm)", isOn: $viewModel.useMetricUnits)
            }
        }
        .navigationTitle("Settings")
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Save") { viewModel.save() } } }
    }
}



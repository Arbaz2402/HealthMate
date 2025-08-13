//
//  DashboardView.swift
//  HealthMate
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: DashboardViewModel

    init() {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    card(title: "Consumed", value: Int(viewModel.caloriesConsumedToday), unit: "kcal", color: .orange)
                    card(title: "Burned", value: Int(viewModel.totalBurnedToday), unit: "kcal", color: .green)
                    card(title: "Net", value: Int(viewModel.netCaloriesToday), unit: "kcal", color: .blue)

                    HStack(spacing: 16) {
                        smallCard(title: "Steps", value: viewModel.stepsToday, unit: "")
                        smallCard(title: "Active kcal", value: Int(viewModel.activeEnergyToday), unit: "kcal")
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Refresh") { Task { await viewModel.refresh() } }
                }
            }
            .task { await viewModel.refresh() }
        }
    }

    private func card(title: String, value: Int, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            HStack(alignment: .firstTextBaseline) {
                Text("\(value)").font(.largeTitle).bold()
                Text(unit).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)))
    }

    private func smallCard(title: String, value: Int, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline)
            HStack(alignment: .firstTextBaseline) {
                Text("\(value)").font(.title2).bold()
                if !unit.isEmpty { Text(unit).foregroundStyle(.secondary) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.1)))
    }
}



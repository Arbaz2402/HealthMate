//
//  HealthPermissions.swift
//  HealthMate
//

import SwiftUI

struct HealthPermissionsView: View {
    @State private var isRequesting = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Health Access")
                .font(.title2)
                .bold()
            Text("We use Health data for steps, active energy, height, weight, age and sex to personalize your daily stats.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button(action: request) {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Allow Health Access")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
        .padding()
    }

    private func request() {
        isRequesting = true
        Task {
            do {
                try await HealthKitManager.shared.requestAuthorization()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isRequesting = false
        }
    }
}



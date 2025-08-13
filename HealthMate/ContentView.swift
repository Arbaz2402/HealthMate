//
//  ContentView.swift
//  HealthMate
//
//  Created by Arbaz Kaladiya on 13/08/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "speedometer") }

            NavigationView { FoodLogView() }
                .tabItem { Label("Food", systemImage: "fork.knife") }

            NavigationView { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }

            NavigationView { HealthPermissionsView() }
                .tabItem { Label("Health", systemImage: "heart.fill") }

            NavigationView { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

#Preview {
    ContentView()
}

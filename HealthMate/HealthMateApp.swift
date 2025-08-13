//
//  HealthMateApp.swift
//  HealthMate
//
//  Created by Arbaz Kaladiya on 13/08/25.
//

import SwiftUI

@main
struct HealthMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

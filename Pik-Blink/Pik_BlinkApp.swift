//
//  Pik_BlinkApp.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

@main
struct Pik_BlinkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PikItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

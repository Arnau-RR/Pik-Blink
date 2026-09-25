//
//  Pik_BlinkApp.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData
import AppIntents

@main
struct Pik_BlinkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PikItem.self,
            PikDraft.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        let container = sharedModelContainer   // ← copia, no self

        AppDependencyManager.shared.add(
            dependency: container
        )
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

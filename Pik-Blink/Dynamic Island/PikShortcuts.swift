//
//  PikShortcuts.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents

struct PikShortcuts: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewPikIntent(),
            phrases: [
                "Nuevo \\(.applicationName)",
                "Crear \\(.applicationName)",
                "Nou \\(.applicationName)",
                "Crea \\(.applicationName)",
                "New \\(.applicationName)",
                "Create \\(.applicationName)"
            ],
            shortTitle: "New Pik",
            systemImageName: "plus.circle"
        )
    }
}

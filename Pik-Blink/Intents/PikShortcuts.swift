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
                "Nuevo Pik en \\(.applicationName)",
                "Crear Pik en \\(.applicationName)",
                "Nou Pik a \\(.applicationName)",
                "Crea un Pik a \\(.applicationName)",
                "New Pik in \\(.applicationName)",
                "Create Pik in \\(.applicationName)"
            ],
            shortTitle: "New Pik",
            systemImageName: "plus.circle"
        )
    }
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: NewPikIntent(),
//            phrases: [
//                "New Pik in \(.applicationName)",
//                "Create Pik in \(.applicationName)"
//            ],
//            shortTitle: "New Pik",
//            systemImageName: "plus.circle"
//        )
//    }
}

//
//  Pik_BlinkApp.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData
import AppIntents

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english = "en"
    case spanish = "es"
    case catalan = "ca"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "System"
        case .english: return "English"
        case .spanish: return "Español"
        case .catalan: return "Català"
        }
    }

    var locale: Locale {
        switch self {
        case .system: return .autoupdatingCurrent
        case .english: return Locale(identifier: "en")
        case .spanish: return Locale(identifier: "es")
        case .catalan: return Locale(identifier: "ca")
        }
    }
}

@main
struct Pik_BlinkApp: App {

    /// Debe coincidir con el App Group de ambos targets
    static let sharedGroupID = "group.com.arnaurivas.PikBlink"

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PikItem.self,
            PikDraft.self,
            FavoritePlace.self
        ])

        let sharedURL = FileManager.default
            .containerURL(
                forSecurityApplicationGroupIdentifier: Pik_BlinkApp.sharedGroupID
            )!
            .appendingPathComponent("Pik.sqlite")

        let configuration = ModelConfiguration(
            schema: schema,
            url: sharedURL
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: configuration
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @AppStorage("appLanguage") private var language = AppLanguage.system.rawValue
    @AppStorage("appAppearance") private var appearance = AppAppearance.system.rawValue

    init() {
        let container = sharedModelContainer

        AppDependencyManager.shared.add(
            dependency: container
        )

        Bundle.setLanguage(
            language == AppLanguage.system.rawValue ? nil : language
        )
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(
                    \.locale,
                    AppLanguage(rawValue: language)?.locale ?? .autoupdatingCurrent
                )
                .preferredColorScheme(
                    AppAppearance(rawValue: appearance)?.colorScheme
                )
                .id(language)
        }
        .modelContainer(sharedModelContainer)
    }
}

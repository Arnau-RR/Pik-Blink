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
        case .system: String(localized: "System")
        case .light: String(localized: "Light")
        case .dark: String(localized: "Dark")
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
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
        case .system: return String(localized: "System")
        case .english: return String(localized: "English")
        case .spanish: return String(localized: "Español")
        case .catalan: return String(localized: "Català")
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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PikItem.self,
            PikDraft.self,
            FavoritePlace.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
        
        Bundle.setLanguage(language == AppLanguage.system.rawValue ? nil : language)

        
            print("Bundle path for es:", Bundle.main.path(forResource: "es", ofType: "lproj") ?? "NOT FOUND")
            print("Bundle path for ca:", Bundle.main.path(forResource: "ca", ofType: "lproj") ?? "NOT FOUND")
            print("Localizations disponibles:", Bundle.main.localizations)
        
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

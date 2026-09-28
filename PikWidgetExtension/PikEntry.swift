////
////  PikEntry.swift
////  Pik-Blink
////
////  Created by Arnau on 26/09/2026.
////
//

import WidgetKit
import SwiftData
import AppIntents

struct PikEntry: TimelineEntry {
    let date: Date
    let piks: [PikItem]
}

struct PikProvider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> PikEntry {
        .init(date: .now, piks: [])
    }

    func snapshot(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> PikEntry {
        .init(date: .now, piks: loadPiks())
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<PikEntry> {

        let entry = PikEntry(
            date: .now,
            piks: loadPiks()
        )

        return Timeline(
            entries: [entry],
            policy: .atEnd
        )
    }

    private func loadPiks() -> [PikItem] {

        let schema = Schema([
            PikItem.self,
            PikDraft.self,
            FavoritePlace.self
        ])

        let url = FileManager.default
            .containerURL(
                forSecurityApplicationGroupIdentifier: "group.com.arnaurivas.PikBlink"
            )!
            .appendingPathComponent("Pik.sqlite")

        let configuration = ModelConfiguration(schema: schema, url: url)
        let container = try! ModelContainer(for: schema, configurations: configuration)
        let context = ModelContext(container)

        let descriptor = FetchDescriptor<PikItem>(
            sortBy: [SortDescriptor(\PikItem.remindAt, order: .forward)]
        )

        let all = (try? context.fetch(descriptor)) ?? []

        let calendar = Calendar.current

        return all.filter { pik in
            guard pik.status == .pending else { return false }

            switch pik.reminderType ?? .none {

            case .none:
                // Solo mostrar los creados hoy
                return calendar.isDateInToday(pik.createdAt)

            case .location:
                // No mostrar recordatorios por ubicación en el widget
                return false

            case .date:
                guard let date = pik.remindAt else { return false }
                // Solo recordatorios programados para hoy
                return calendar.isDateInToday(date)
            }
        }
    }
}

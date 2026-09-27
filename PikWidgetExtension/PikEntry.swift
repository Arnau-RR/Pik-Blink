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
        let start = calendar.startOfDay(for: .now)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!

        return all.filter { pik in
            guard pik.status == .pending else { return false }

            guard let type = pik.reminderType else {
                return true
            }

            switch type {
            case .none:
                return true

            case .location:
                return true

            case .date:
                guard let date = pik.remindAt else { return false }
                return date >= start && date < end
            }
        }
    }
}

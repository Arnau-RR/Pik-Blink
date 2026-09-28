//
//  SnoozePikIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 28/09/2026.
//

import AppIntents
import SwiftData
import WidgetKit
import ActivityKit

struct SnoozePikIntent: LiveActivityIntent {

    static var title: LocalizedStringResource = "live.activity.snooze"
    static var isDiscoverable: Bool = false

    @Parameter(title: "Pik ID")
    var id: String

    init() {}

    init(id: UUID) {
        self.id = id.uuidString
    }

    func perform() async throws -> some IntentResult {

        let schema = Schema([
            PikItem.self,
            PikDraft.self,
            FavoritePlace.self
        ])

        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.arnaurivas.PikBlink")!
            .appendingPathComponent("Pik.sqlite")

        let configuration = ModelConfiguration(schema: schema, url: url)
        let container = try ModelContainer(for: schema, configurations: configuration)
        let context = ModelContext(container)

        let items = try context.fetch(FetchDescriptor<PikItem>())

        if let pik = items.first(where: { $0.id.uuidString == id }) {

            // Posponer 15 minutos desde ahora
            pik.reminderType = .date
            pik.remindAt = Date().addingTimeInterval(15 * 60)

            try context.save()

            NotificationManager.shared.update(for: pik)

            if let activity = Activity<PikLiveActivityAttributes>.activities.first(
                where: { $0.attributes.id == pik.id }
            ) {

                let newDate = pik.remindAt!

                let state = PikLiveActivityAttributes.ContentState(
                    title: pik.text,
                    reminderType: .date,
                    reminderDate: newDate,
                    placeName: pik.placeName,
                    isCompleted: false
                )

                await activity.update(
                    ActivityContent(
                        state: state,
                        staleDate: newDate,
                        relevanceScore: 100
                    )
                )
            }

            WidgetCenter.shared.reloadTimelines(ofKind: "PikWidget")
        }

        return .result()
    }
}

//
//  SetQuickReminderIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData
import SwiftUI

struct SetQuickReminderIntent: AppIntent {

    static let title: LocalizedStringResource = "app.intent.set.quick.reminder.title"
    static var isDiscoverable: Bool = false

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "app.intent.set.quick.reminder.parameter.draft")
    var draft: PikDraftEntity

    @Parameter(title: "app.intent.set.quick.reminder.parameter.option")
    var option: QuickReminderOption

    init() {}

    init(draft: PikDraftEntity, option: QuickReminderOption) {
        self.draft = draft
        self.option = option
    }

    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {

        let context = ModelContext(modelContainer)

        let draftID = draft.id

        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate<PikDraft> {
                $0.id == draftID
            }
        )

        let favorites = try context.fetch(FetchDescriptor<FavoritePlace>())
            .map {
                FavoritePlaceSnippet(
                    label: $0.label,
                    name: $0.name,
                    address: $0.address,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }

        guard let model = try context.fetch(descriptor).first else {
            return .result {
                Text("app.intent.set.quick.reminder.error.draft.not.found")
            }
        }

        let calendar = Calendar.current
        let now = Date()

        switch option {

        case .thirtyMinutes:
            model.isPickingCustomDate = false
            model.quickReminder = .thirtyMinutes
            model.reminderType = .date
            model.remindAt = calendar.date(byAdding: .minute, value: 30, to: now)

        case .oneHour:
            model.isPickingCustomDate = false
            model.quickReminder = .oneHour
            model.reminderType = .date
            model.remindAt = calendar.date(byAdding: .hour, value: 1, to: now)

        case .twoHours:
            model.isPickingCustomDate = false
            model.quickReminder = .twoHours
            model.reminderType = .date
            model.remindAt = calendar.date(byAdding: .hour, value: 2, to: now)

        case .custom:
            model.isPickingCustomDate = true
            model.quickReminder = .custom
            model.reminderType = .date
        }

        try context.save()

        let entity = PikDraftEntity(
            id: model.id,
            text: model.text
        )

        return .result {
            EditSnippetContent(
                draft: entity,
                model: model,
                favorites: favorites
            )
        }
    }
}

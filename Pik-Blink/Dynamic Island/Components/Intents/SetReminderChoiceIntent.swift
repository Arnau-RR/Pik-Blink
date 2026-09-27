//
//  SetReminderChoiceIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData
import SwiftUI

struct SetReminderChoiceIntent: AppIntent {

    static let title: LocalizedStringResource = "app.intent.set.reminder.choice.title"
    static var isDiscoverable: Bool = false

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "app.intent.set.reminder.choice.parameter.draft")
    var draft: PikDraftEntity

    @Parameter(title: "app.intent.set.reminder.choice.parameter.choice")
    var choice: ReminderChoice

    init() {}

    init(draft: PikDraftEntity, choice: ReminderChoice) {
        self.draft = draft
        self.choice = choice
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
                Text("app.intent.set.reminder.choice.error.draft.not.found")
            }
        }

        switch choice {

        case .none:
            model.reminderType = .none
            model.remindAt = nil
            model.isPickingCustomDate = false
            model.placeLabel = nil
            model.placeName = nil
            model.placeAddress = nil
            model.latitude = nil
            model.longitude = nil
            model.isPickingLocation = false

        case .time:
            model.reminderType = .date
            model.placeLabel = nil
            model.placeName = nil
            model.placeAddress = nil
            model.latitude = nil
            model.longitude = nil

        case .location:
            model.reminderType = .location
            model.remindAt = nil
            model.isPickingCustomDate = false
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

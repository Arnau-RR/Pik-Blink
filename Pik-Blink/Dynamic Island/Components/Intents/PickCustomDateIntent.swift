//
//  PickCustomDateIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData
import SwiftUI

struct PickCustomDateIntent: AppIntent {

    static let title: LocalizedStringResource = "app.intent.pick.custom.date.title"
    static var isDiscoverable: Bool = false

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "app.intent.pick.custom.date.parameter.draft")
    var draft: PikDraftEntity

    @Parameter(
        title: "app.intent.pick.custom.date.parameter.reminder.date",
        requestValueDialog: IntentDialog("app.intent.pick.custom.date.dialog.request")
    )
    var date: Date

    init() {}
    init(draft: PikDraftEntity) {
        self.draft = draft
    }

    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {

        let context = ModelContext(modelContainer)
        let draftID = draft.id

        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate<PikDraft> { $0.id == draftID }
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
            return .result { Text("app.intent.pick.custom.date.error.draft.not.found") }
        }

        model.remindAt = date
        model.reminderType = .date

        try context.save()

        let entity = PikDraftEntity(id: model.id, text: model.text)

        return .result {
            EditSnippetContent(draft: entity, model: model, favorites: favorites)
        }
    }
}

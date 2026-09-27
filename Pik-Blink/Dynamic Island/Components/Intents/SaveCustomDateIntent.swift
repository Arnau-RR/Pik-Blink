//
//  SaveCustomDateIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//


import AppIntents
import SwiftData
import SwiftUI

struct SaveCustomDateIntent: AppIntent {

    static let title: LocalizedStringResource = "Save custom date"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    @Parameter(title: "Date")
    var date: Date

    init() {}

    init(draft: PikDraftEntity, date: Date) {
        self.draft = draft
        self.date = date
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
                Text("Draft not found")
            }
        }

        model.remindAt = date
        model.isPickingCustomDate = false

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

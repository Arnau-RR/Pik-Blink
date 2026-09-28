//
//  EditTextSnippet.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftUI
import SwiftData

struct EditTextSnippet: SnippetIntent {

    static let title: LocalizedStringResource = "New Pik"

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    init() {}

    init(draft: PikDraftEntity) {
        self.draft = draft
    }
    
    @Dependency
    private var modelContainer: ModelContainer

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

        return .result {
            EditSnippetContent(
                draft: draft,
                model: model,
                favorites: favorites
            )
        }
    }
}

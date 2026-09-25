//
//  PickLocationIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData
import SwiftUI

struct PickLocationIntent: AppIntent {

    static let title: LocalizedStringResource = "Pick location"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

//    @Parameter(
//        title: "Location",
//        requestValueDialog: "Where should I remind you?"
//    )
//    var location: String
    
    @Parameter(
        title: "Place",
        requestValueDialog: "Where should I remind you?"
    )
    var place: PlaceEntity

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

        guard let model = try context.fetch(descriptor).first else {
            return .result { Text("Draft not found") }
        }

        model.reminderType = .location
        //model.locationName = location
        model.locationName = place.title
        model.latitude = place.latitude
        model.longitude = place.longitude

        try context.save()

        let entity = PikDraftEntity(
            id: model.id,
            text: model.text
        )

        return .result {
            EditSnippetContent(
                draft: entity,
                model: model
            )
        }
    }
}

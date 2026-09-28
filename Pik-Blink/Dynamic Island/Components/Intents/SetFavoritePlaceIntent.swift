//
//  SetFavoritePlaceIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import AppIntents
import SwiftData
import SwiftUI

struct SetFavoritePlaceIntent: AppIntent {

    static let title: LocalizedStringResource = "app.intent.set.favorite.place.title"
    static var isDiscoverable: Bool = false

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "app.intent.set.favorite.place.parameter.draft")
    var draft: PikDraftEntity

    @Parameter(title: "app.intent.set.favorite.place.parameter.label")
    var label: String

    @Parameter(title: "app.intent.set.favorite.place.parameter.name")
    var name: String

    @Parameter(title: "app.intent.set.favorite.place.parameter.address")
    var address: String

    @Parameter(title: "app.intent.set.favorite.place.parameter.latitude")
    var latitude: Double

    @Parameter(title: "app.intent.set.favorite.place.parameter.longitude")
    var longitude: Double

    init() {}

    init(
        draft: PikDraftEntity,
        label: String,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.draft = draft
        self.label = label
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {

        let context = ModelContext(modelContainer)
        let draftID = draft.id

        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate<PikDraft> { $0.id == draftID }
        )

        guard let model = try context.fetch(descriptor).first else {
            return .result { Text("app.intent.set.favorite.place.error.draft.not.found") }
        }

        model.reminderType = .location
        model.placeLabel = label
        model.placeName = name
        model.placeAddress = address
        model.latitude = latitude
        model.longitude = longitude
        model.isPickingLocation = false

        try context.save()

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

        let entity = PikDraftEntity(id: model.id, text: model.text)

        return .result {
            EditSnippetContent(
                draft: entity,
                model: model,
                favorites: favorites
            )
        }
    }
}

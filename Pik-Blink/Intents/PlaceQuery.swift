//
//  PlaceQuery.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
internal import MapKit

struct PlaceQuery: EntityStringQuery {

    func suggestedEntities() async throws -> [PlaceEntity] {
        []
    }

    func entities(
        matching string: String
    ) async throws -> [PlaceEntity] {

        guard !string.isEmpty else { return [] }

        let completer = await CompleterService()
        let completions = try await completer.search(query: string)

        var places: [PlaceEntity] = []

        for completion in completions {

            let request = MKLocalSearch.Request(completion: completion)

            guard let response = try? await MKLocalSearch(request: request).start(),
                  let item = response.mapItems.first else {
                continue
            }

            places.append(
                PlaceEntity(
                    id: UUID().uuidString,
                    title: completion.title,
                    subtitle: completion.subtitle,
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude
                )
            )
        }

        return places
    }

    func entities(
        for identifiers: [PlaceEntity.ID]
    ) async throws -> [PlaceEntity] {
        []
    }
}

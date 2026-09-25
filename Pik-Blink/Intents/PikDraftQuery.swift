//
//  PikDraftQuery.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData

struct PikDraftQuery: EntityQuery {

    @Dependency
    var modelContainer: ModelContainer

    func entities(
        for identifiers: [UUID]
    ) async throws -> [PikDraftEntity] {

        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate {
                identifiers.contains($0.id)
            }
        )

        let drafts = try context.fetch(descriptor)

        return drafts.map {
            PikDraftEntity(
                id: $0.id,
                text: $0.text
            )
        }
    }

    func suggestedEntities() async throws -> [PikDraftEntity] {
        []
    }
}

//import SwiftData
//import AppIntents
//
//struct PikDraftQuery: EntityQuery {
//
//    func entities(
//        for identifiers: [UUID]
//    ) async throws -> [PikDraftEntity] {
//
//        []
//    }
//
//    func suggestedEntities() async throws -> [PikDraftEntity] {
//        []
//    }
//}

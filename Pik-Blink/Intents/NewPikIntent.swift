//
//  NewPikIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents
import SwiftData

struct NewPikIntent: AppIntent {

    static let title: LocalizedStringResource = "New Pik"
    static let openAppWhenRun = false

    @Dependency
    private var modelContainer: ModelContainer

    @MainActor
        func perform() async throws -> some IntentResult {

            let context = ModelContext(modelContainer)

            // 1. Crear el borrador
            let draft = PikDraft()
            context.insert(draft)
            try context.save()

            // 2. Convertirlo en AppEntity
            let entity = PikDraftEntity(
                id: draft.id,
                text: draft.text
            )

            // 3. Mostrar el snippet
            try await requestConfirmation(
                snippetIntent: EditTextSnippet(draft: entity)
            )

            return .result()
        }
    
//    @MainActor
//    func perform() async throws -> some IntentResult {
//
//        let context = ModelContext(modelContainer)
//
//        let draft = PikDraft()
//        context.insert(draft)
//
//        try context.save()
//
//        return .result()
//    }
}

//import AppIntents
//import SwiftData
//
//struct NewPikIntent: AppIntent {
//
//    static let title: LocalizedStringResource = "New Pik"
//    static let openAppWhenRun = false
//
//    @Dependency
//    private var modelContext: ModelContext
//    
//    @Dependency
//    var modelContainer: ModelContainer
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//
//        let draft = PikDraft()
//        modelContext.insert(draft)
//
//        try modelContext.save()
//
//        return .result()
//    }
//    
////    @MainActor
////    func perform() async throws -> some IntentResult {
////
////        let context = ModelContext(modelContainer)
////
////        let draft = PikDraft()
////        context.insert(draft)
////
////        try context.save()
////
////        let entity = PikDraftEntity(
////            id: draft.id,
////            text: draft.text
////        )
////
////        try await requestConfirmation(
////            snippetIntent: EditTextSnippet(draft: entity)
////        )
////
////        return .result()
////    }
//}

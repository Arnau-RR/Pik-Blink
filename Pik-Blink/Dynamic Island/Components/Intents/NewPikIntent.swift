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
    func perform() async throws -> some IntentResult & ShowsSnippetIntent {
        
        let context = ModelContext(modelContainer)
        
        let draft = PikDraft()
        context.insert(draft)
        try context.save()
        
        let entity = PikDraftEntity(
            id: draft.id,
            text: draft.text
        )
        
        // Sin requestConfirmation: esto muestra el snippet
        // sin los botones nativos del sistema.
        return .result(snippetIntent: EditTextSnippet(draft: entity))
    }
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
//    private var modelContainer: ModelContainer
//    
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        
//        let context = ModelContext(modelContainer)
//        
//        // 1. Crear el borrador
//        let draft = PikDraft()
//        context.insert(draft)
//        try context.save()
//        
//        // 2. Convertirlo en AppEntity
//        let entity = PikDraftEntity(
//            id: draft.id,
//            text: draft.text
//        )
//        
//        // 3. Mostrar el snippet
//        try await requestConfirmation(
//            snippetIntent: EditTextSnippet(draft: entity)
//        )
//        
////        return .result()
//        return .result(
//            opensIntent: EditTextSnippet(draft: entity)
//        )
//    }
//}

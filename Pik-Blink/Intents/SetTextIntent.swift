////
////  SetTextIntent.swift
////  Pik-Blink
////
////  Created by Arnau on 25/09/2026.
////
//

import AppIntents
import SwiftData
import SwiftUI

struct SetTextIntent: AppIntent {

    static let title: LocalizedStringResource = "Edit text"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    init() {}

    init(draft: PikDraftEntity) {
        self.draft = draft
    }
    
    @Parameter(
        title: "Your idea",
        requestValueDialog: "What do you want to remember?"
    )
    var text: String

    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {

        let context = ModelContext(modelContainer)

        let draftID = draft.id

        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate<PikDraft> {
                $0.id == draftID
            }
        )

        guard let draftModel = try context.fetch(descriptor).first else {
            return .result {
                Text("Draft not found")
            }
        }

        draftModel.text = text
        try context.save()

//        let entity = PikDraftEntity(
//            id: draftModel.id,
//            text: draftModel.text
//        )
//
//        return .result {
//            PikSnippetTextField(
//                draft: entity,
//                text: draftModel.text
//            )
//            .padding()
//        }
        
        let entity = PikDraftEntity(
            id: draftModel.id,
            text: draftModel.text
        )

        return .result {
            EditSnippetContent(
                draft: entity,
                model: draftModel
            )
        }
    }
//    @MainActor
//    func perform() async throws -> some IntentResult {
//
//        let context = ModelContext(modelContainer)
//
//        let draftID = draft.id
//
//        let descriptor = FetchDescriptor<PikDraft>(
//            predicate: #Predicate<PikDraft> {
//                $0.id == draftID
//            }
//        )
//
//        guard let draftModel = try context.fetch(descriptor).first else {
//            return .result()
//        }
//
//        draftModel.text = text
//        try context.save()
//
//        EditTextSnippet.reload()
//
//        return .result()
//    }
}

//import AppIntents
//import SwiftData
//
//struct SetTextIntent: AppIntent {
//
//    static let title: LocalizedStringResource = "Edit text"
//
//    @Dependency
//    private var modelContainer: ModelContainer
//
//    @Parameter(title: "Draft")
//    var draft: PikDraftEntity
//
//    @Parameter(
//        title: "Your idea",
//        requestValueDialog: "What do you want to remember?"
//    )
//    var text: String
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//
//        let context = ModelContext(modelContainer)
//
////        let descriptor = FetchDescriptor<PikDraft>(
////            predicate: #Predicate { $0.id == draft.id }
////        )
//        let draftID = draft.id
//
//        let descriptor = FetchDescriptor<PikDraft>(
//            predicate: #Predicate<PikDraft> {
//                $0.id == draftID
//            }
//        )
//
//        guard let draftModel = try context.fetch(descriptor).first else {
//            return .result()
//        }
//
//        draftModel.text = text
//        try context.save()
//
//        EditTextSnippet.reload()
//
//        return .result()
//    }
//}

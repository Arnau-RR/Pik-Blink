////
////  EditTextSnippet.swift
////  Pik-Blink
////
////  Created by Arnau on 25/09/2026.
////
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

        guard let model = try context.fetch(descriptor).first else {
            return .result {
                Text("Draft not found")
            }
        }

//        return .result {
//            PikSnippetTextField(
//                draft: draft,
//                text: model.text
//            )
//        }
        return .result {
            EditSnippetContent(
                draft: draft,
                model: model
            )
        }
    }

//    func perform() async throws -> some IntentResult & ShowsSnippetView {
//
//        .result {
//            VStack(alignment: .leading, spacing: 16) {
//
//                Text("Pik Blink")
//                    .font(.headline)
//
//                PikSnippetTextField(draft: draft)
//            }
//            .padding()
//        }
//    }
}

//import AppIntents
//import SwiftUI
//
//struct EditTextSnippet: SnippetIntent {
//
//    static let title: LocalizedStringResource = "New Pik"
//
//    @Parameter(title: "Draft")
//    var draft: PikDraftEntity
//
//    init() {}
//
//    init(draft: PikDraftEntity) {
//        self.draft = draft
//    }
//
//    func perform() async throws -> some IntentResult & ShowsSnippetView {
//
//        .result {
//            VStack(alignment: .leading, spacing: 16) {
//
//                Text("Pik Blink")
//                    .font(.headline)
//
//                PikSnippetTextField(draft: draft)
//            }
//            .padding()
//        }
//    }
//}
//
////import AppIntents
////import SwiftUI
////
////struct EditTextSnippet: SnippetIntent {
////
////    static let title: LocalizedStringResource = "New Pik"
////
////    @Parameter(title: "Draft")
////    var draft: PikDraftEntity
////
////    init() {}
////
////    init(draft: PikDraftEntity) {
////        self.draft = draft
////    }
////
////    func perform() async throws -> some IntentResult & ShowsSnippetView {
////
////        .result {
////            VStack(alignment: .leading, spacing: 8) {
////
////                Text("Pik Blink")
////                    .font(.caption)
////                    .foregroundStyle(.secondary)
////
////                Text(
////                    draft.text.isEmpty
////                    ? "Tap Edit to start"
////                    : draft.text
////                )
////                .font(.headline)
////                
////                Button(
////                    intent: SetTextIntent(draft: $draft)
////                ) {
////                    Label("Edit text", systemImage: "square.and.pencil")
////                }
////            }
////            .padding()
////        }
////    }
////}

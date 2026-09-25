////
////  SetReminderChoiceIntent.swift
////  Pik-Blink
////
////  Created by Arnau on 25/09/2026.
////
//
//import AppIntents
//import SwiftData
//import SwiftUI
//

import AppIntents
import SwiftData
import SwiftUI

struct SetReminderChoiceIntent: AppIntent {

    static let title: LocalizedStringResource = "Reminder choice"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    @Parameter(title: "Choice")
    var choice: ReminderChoice

    init() {}

    init(draft: PikDraftEntity, choice: ReminderChoice) {
        self.draft = draft
        self.choice = choice
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

        guard let model = try context.fetch(descriptor).first else {
            return .result {
                Text("Draft not found")
            }
        }

        switch choice {

        case .none:
            model.reminderType = .none

        case .time:
            model.reminderType = .date

        case .location:
            model.reminderType = .location
        }

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

//struct SetReminderChoiceIntent: AppIntent {
//
//    static let title: LocalizedStringResource = "Choose reminder"
//
//    @Dependency
//    private var modelContainer: ModelContainer
//
//    @Parameter(title: "Draft")
//    var draft: PikDraftEntity
//
//    @Parameter(title: "Choice")
//    var choice: ReminderChoice
//
//    init() {}
//
//    init(draft: PikDraftEntity, choice: ReminderChoice) {
//        self.draft = draft
//        self.choice = choice
//    }
//
//    @MainActor
//    func perform() async throws -> some IntentResult & ShowsSnippetView {
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
//        guard let model = try context.fetch(descriptor).first else {
//            return .result { Text("Draft not found") }
//        }
//
//        switch choice {
//        case .none:
//            model.reminderType = .none
//
//        case .time:
//            model.reminderType = .date
//
//        case .location:
//            model.reminderType = .location
//        }
//
//        try context.save()
//
//        let entity = PikDraftEntity(
//            id: model.id,
//            text: model.text
//        )
//
//        return .result {
//            EditSnippetContent(
//                draft: entity,
//                model: model
//            )
//        }
//    }
//}

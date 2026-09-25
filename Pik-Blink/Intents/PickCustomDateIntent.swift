//
//  PickCustomDateIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//


import AppIntents
import SwiftData
import SwiftUI

struct PickCustomDateIntent: AppIntent {

    static let title: LocalizedStringResource = "Pick custom date"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    @Parameter(
        title: "Reminder date",
        requestValueDialog: "When should I remind you?"
    )
    var date: Date

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

        model.remindAt = date
        model.reminderType = .date

        try context.save()

        let entity = PikDraftEntity(id: model.id, text: model.text)

        return .result {
            EditSnippetContent(draft: entity, model: model)
        }
    }
}

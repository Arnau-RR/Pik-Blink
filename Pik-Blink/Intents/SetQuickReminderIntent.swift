//
//  SetQuickReminderIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//


import AppIntents
import SwiftData
import SwiftUI

struct SetQuickReminderIntent: AppIntent {

    static let title: LocalizedStringResource = "Set reminder"

    @Dependency
    private var modelContainer: ModelContainer

    @Parameter(title: "Draft")
    var draft: PikDraftEntity

    @Parameter(title: "Option")
    var option: QuickReminderOption

    init() {}

    init(draft: PikDraftEntity, option: QuickReminderOption) {
        self.draft = draft
        self.option = option
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

        let calendar = Calendar.current
        let now = Date()

        switch option {

        case .today:
            model.isPickingCustomDate = false
            model.remindAt = calendar.date(
                bySettingHour: 17,
                minute: 0,
                second: 0,
                of: now
            )

        case .tonight:
            model.isPickingCustomDate = false
            model.remindAt = calendar.date(
                bySettingHour: 20,
                minute: 0,
                second: 0,
                of: now
            )

        case .tomorrow:
            model.isPickingCustomDate = false
            let tomorrow = calendar.date(
                byAdding: .day,
                value: 1,
                to: now
            )!

            model.remindAt = calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: tomorrow
            )

        case .custom:
            model.isPickingCustomDate = true
            break
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

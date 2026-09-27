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
        
        guard let model = try context.fetch(descriptor).first else {
            return .result {
                Text("Draft not found")
            }
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch option {
            
        case .thirtyMinutes:
            model.isPickingCustomDate = false
            model.remindAt = calendar.date(byAdding: .minute, value: 30, to: now)
            
        case .oneHour:
            model.isPickingCustomDate = false
            model.remindAt = calendar.date(byAdding: .hour, value: 1, to: now)
            
        case .twoHours:
            model.isPickingCustomDate = false
            model.remindAt = calendar.date(byAdding: .hour, value: 2, to: now)
            
        case .custom:
            model.isPickingCustomDate = true
        }
        
        try context.save()
        
        let entity = PikDraftEntity(
            id: model.id,
            text: model.text
        )
        
        return .result {
            EditSnippetContent(
                draft: entity,
                model: model,
                favorites: favorites
            )
        }
    }
}

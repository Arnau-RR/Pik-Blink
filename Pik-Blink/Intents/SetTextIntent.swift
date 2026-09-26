//
//  SetTextIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
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
        
        guard let draftModel = try context.fetch(descriptor).first else {
            return .result {
                Text("Draft not found")
            }
        }
        
        draftModel.text = String(text.prefix(100))
        try context.save()
        
        let entity = PikDraftEntity(
            id: draftModel.id,
            text: draftModel.text
        )
        
        return .result {
            EditSnippetContent(
                draft: entity,
                model: draftModel,
                favorites: favorites
                
            )
        }
    }
}

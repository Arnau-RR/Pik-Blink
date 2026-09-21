//
//  MainViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var pickList: [PikItem] = []
    
    private var modelContext: ModelContext?

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadMockIfNeeded(context: ModelContext) throws {
        let descriptor = FetchDescriptor<PikItem>()
        
        let items = try context.fetch(descriptor)
        
        guard items.isEmpty else {
            pickList = items
            return
        }
        
        for item in PikItem.mockList {
            context.insert(item)
        }
        
        try context.save()
        pickList = try context.fetch(descriptor)
        
    }
    
    func toggle(_ item: PikItem) {
        guard let modelContext else { return }

        item.status = item.isCompleted ? .pending : .completed
        try? modelContext.save()
    }

    func archive(_ item: PikItem) {
        guard let modelContext else { return }

        item.status = .archived
        try? modelContext.save()
    }

    func delete(_ item: PikItem) {
        guard let modelContext else { return }

        modelContext.delete(item)
        try? modelContext.save()
    }
}

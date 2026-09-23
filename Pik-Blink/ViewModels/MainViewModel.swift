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
    
    //@Published var pickList: [PikItem] = []
    @Published var createNewItemPressed: Bool = false
    @Published var piksSavedInDB: [PikItem] = []
    @Published var selectedTab = 0
    
    private var modelContext: ModelContext?
    
    var filteredPiks: [PikItem] {
        switch selectedTab {
            case 0:
                return pendingPiks
            case 1:
                return completedPiks
            case 2:
                return archivedPiks
            default:
                return []
        }
    }
    
    var pendingPiks: [PikItem] {
        piksSavedInDB.filter { $0.status == .pending }
    }

    var archivedPiks: [PikItem] {
        piksSavedInDB.filter { $0.status == .archived }
    }

    var completedPiks: [PikItem] {
        piksSavedInDB.filter { $0.status == .completed }
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadPiksStored() async {
        guard let modelContext else { return }

        do {
            let descriptor = FetchDescriptor<PikItem>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )

            piksSavedInDB = try modelContext.fetch(descriptor)
        } catch {
            print("Error cargando PikItems:", error)
        }
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

        piksSavedInDB.removeAll { $0.id == item.id }
    }
    
    func reload() {
        guard let modelContext else { return }

        let descriptor = FetchDescriptor<PikItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        piksSavedInDB = (try? modelContext.fetch(descriptor)) ?? []
    }
}

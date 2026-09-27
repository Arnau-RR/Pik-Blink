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
final class PikViewModel: ObservableObject {

    @Published var createNewItemPressed = false
    @Published var editExistingItemPressed = false
    //@Published var piksSavedInDB: [PikItem] = []
    @Published var selectedTab = 0
    @Published var notificationAuthorized = false

    private var allPiks: [PikItem] = []
    private var modelContext: ModelContext?
    private let notifications = NotificationManager.shared
    
    var selectedPik: PikItem?


    // MARK: - Filters

//    var filteredPiks: [PikItem] {
//        switch selectedTab {
//        case 0: return pendingPiks
//        case 1: return completedPiks
//        case 2: return archivedPiks
//        default: return []
//        }
//    }
    
    func filteredPiks(from piks: [PikItem]) -> [PikItem] {
        switch selectedTab {
        case 0: return piks.filter { $0.status == .pending }
        case 1: return piks.filter { $0.status == .completed }
        case 2: return piks.filter { $0.status == .archived }
        default: return []
        }
    }

    func pendingPiks(from piks: [PikItem]) -> [PikItem] {
        piks.filter { $0.status == .pending }
    }

    func archivedPiks(from piks: [PikItem]) -> [PikItem] {
        piks.filter { $0.status == .archived }
    }

    func completedPiks(from piks: [PikItem]) -> [PikItem] {
        piks.filter { $0.status == .completed }
    }

    // MARK: - Setup

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func checkNotificationAuthorization() {
        notifications.checkAuthorization { authorized in
            Task { @MainActor in
                self.notificationAuthorized = authorized

                if !authorized {
                    self.notifications.requestPermission { granted in
                        Task { @MainActor in
                            self.notificationAuthorized = granted
                        }
                    }
                }
            }
        }
    }

    // MARK: - Data
//
//    func loadPiksStored() async {
//        guard let modelContext else { return }
//
//        do {
//            let descriptor = FetchDescriptor<PikItem>(
//                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
//            )
//
//            piksSavedInDB = try modelContext.fetch(descriptor)
//
//        } catch {
//            print("Error cargando PikItems:", error)
//        }
//    }

//    func reload() {
//        guard let modelContext else { return }
//
//        let descriptor = FetchDescriptor<PikItem>(
//            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
//        )
//
//        piksSavedInDB = (try? modelContext.fetch(descriptor)) ?? []
//    }

    // MARK: - Actions
    
    func onPressed(_ item: PikItem) {
        //guard let modelContext else { return }
        
        selectedPik = item
        editExistingItemPressed.toggle()
    }

    func toggle(_ item: PikItem) {
        guard let modelContext else { return }

        if item.isCompleted {

            // Vuelve a pendiente
            item.status = .pending

            // Solo reprogramamos si la fecha aún es futura
            if item.reminderType == .date,
               let date = item.remindAt,
               date > Date() {

                notifications.schedule(for: item)
            }

            // Si es por ubicación, sí puede reactivarse siempre
            if item.reminderType == .location {
                notifications.schedule(for: item)
            }

        } else {

            // Se completa
            item.status = .completed
            notifications.remove(for: item)
        }

        try? modelContext.save()
    }

    func archive(_ item: PikItem) {
        guard let modelContext else { return }
        
        notifications.remove(for: item)

        item.status = .archived
        try? modelContext.save()
    }
    
    func unarchive(_ item: PikItem) {
        guard let modelContext else { return }

        item.status = .pending

        switch item.reminderType {
        case .date:
            if let date = item.remindAt, date > Date() {
                notifications.schedule(for: item)
            }

        case .location:
            notifications.schedule(for: item)

        default:
            break
        }

        try? modelContext.save()
    }

    func delete(_ item: PikItem) {
        guard let modelContext else { return }

        notifications.remove(for: item)

        modelContext.delete(item)
        try? modelContext.save()
    }

    // MARK: - Notifications

    func scheduleNotification(for item: PikItem) {
        notifications.schedule(for: item)
    }

    func updateNotification(for item: PikItem) {
        notifications.update(for: item)
    }

    func removeNotification(for item: PikItem) {
        notifications.remove(for: item)
    }
}

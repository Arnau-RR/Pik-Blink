//
//  PikViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Combine
import Foundation
import SwiftData
import WidgetKit

@MainActor
final class PikViewModel: ObservableObject {

    @Published var createNewItemPressed = false
    @Published var editExistingItemPressed = false
    @Published var selectedTab = 0
    @Published var notificationAuthorized = false

    // Search
    @Published var isSearching = false
    @Published var searchText = ""

    private var modelContext: ModelContext?
    private let notifications = NotificationManager.shared

    var selectedPik: PikItem?

    // MARK: - Filters

    func filteredPiks(from piks: [PikItem]) -> [PikItem] {
        let byStatus: [PikItem]

        switch selectedTab {
        case 0: byStatus = piks.filter { $0.status == .pending }
        case 1: byStatus = piks.filter { $0.status == .completed }
        case 2: byStatus = piks.filter { $0.status == .archived }
        default: return []
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return byStatus }

        return byStatus.filter {
            $0.text.localizedCaseInsensitiveContains(query) ||
            ($0.placeName?.localizedCaseInsensitiveContains(query) ?? false)
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

    // MARK: - Search

    func toggleSearch() {
        isSearching.toggle()
        if !isSearching { searchText = "" }
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

    // MARK: - Actions

    func onPressed(_ item: PikItem) {
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

            // Se completa: quita notificación y Live Activity
            item.status = .completed
            notifications.cancel(for: item)
        }

        try? modelContext.save()
        reloadWidgets()
    }

    func archive(_ item: PikItem) {
        guard let modelContext else { return }

        notifications.cancel(for: item)

        item.status = .archived
        try? modelContext.save()
        reloadWidgets()
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
        reloadWidgets()
    }

    func delete(_ item: PikItem) {
        guard let modelContext else { return }

        notifications.cancel(for: item)

        modelContext.delete(item)
        try? modelContext.save()
        reloadWidgets()
    }

    private func reloadWidgets() {
        WidgetCenter.shared.reloadTimelines(ofKind: "PikWidget")

        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName("com.arnaurivas.PikBlink.reload" as CFString),
            nil,
            nil,
            true
        )
    }

    // MARK: - Notifications

    func scheduleNotification(for item: PikItem) {
        notifications.schedule(for: item)
    }

    func updateNotification(for item: PikItem) {
        notifications.update(for: item)
    }

    func removeNotification(for item: PikItem) {
        notifications.cancel(for: item)
    }
}

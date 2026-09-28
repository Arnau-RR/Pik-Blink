//
//  NotificationManager.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import Foundation
import UserNotifications
import CoreLocation
import SwiftData
import UIKit

final class NotificationManager: NSObject {

    static let shared = NotificationManager()

    private let locationManager = CLLocationManager()

    private enum ActionID {
        static let done = "DONE"
        static let snooze15 = "SNOOZE_15"
        static let snooze60 = "SNOOZE_60"
    }

    private static let categoryID = "PIK_REMINDER"
    private static let threadID = "pik-reminders"

    private override init() {
        super.init()
        locationManager.delegate = self
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Notification Permissions

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func checkAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    // MARK: - Location Permissions

    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func checkLocationAuthorization(
        completion: @escaping (CLAuthorizationStatus) -> Void
    ) {
        DispatchQueue.main.async {
            completion(self.locationManager.authorizationStatus)
        }
    }

    // MARK: - Categories

    func registerCategories() {

        // Sin .foreground: completar no abre la app,
        // markAsCompleted ya guarda en SwiftData.
        let done = UNNotificationAction(
            identifier: ActionID.done,
            title: String(localized: "notif.action.done"),
            options: [],
            icon: UNNotificationActionIcon(systemImageName: "checkmark.circle")
        )

        let snooze15 = UNNotificationAction(
            identifier: ActionID.snooze15,
            title: String(localized: "notif.action.snooze15"),
            options: [],
            icon: UNNotificationActionIcon(systemImageName: "clock.arrow.circlepath")
        )

        let snooze60 = UNNotificationAction(
            identifier: ActionID.snooze60,
            title: String(localized: "notif.action.snooze60"),
            options: [],
            icon: UNNotificationActionIcon(systemImageName: "clock")
        )

        let category = UNNotificationCategory(
            identifier: Self.categoryID,
            actions: [],//done, snooze15, snooze60],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: String(localized: "notif.hidden.placeholder"),
            categorySummaryFormat: String(localized: "notif.summary.format"), // "%u recordatorios más"
            options: [.customDismissAction]
        )

        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }

    // MARK: - Content Builder

    private func makeContent(
        title: String,
        subtitle: String,
        id: UUID,
        level: UNNotificationInterruptionLevel,
        relevance: Double = 0.5
    ) -> UNMutableNotificationContent {

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = ""
        content.sound = .default
        content.categoryIdentifier = Self.categoryID
        content.threadIdentifier = Self.threadID
        content.summaryArgument = "Pik"
        content.summaryArgumentCount = 1
        content.interruptionLevel = level
        content.relevanceScore = relevance
        content.userInfo = ["itemID": id.uuidString]
        return content
    }

    // MARK: - Public

    func schedule(for item: PikItem) {

        switch item.reminderType ?? .none {

        case .date:
            scheduleDate(for: item)
            Task { await LiveActivityManager.shared.start(for: item) }

        case .location:
            scheduleLocation(for: item)

        case .none:
            break
        }
    }

    // MARK: - Date Reminder

    private func scheduleDate(for item: PikItem) {

        guard let date = item.remindAt else { return }

        let subtitle: String
        if Calendar.current.isDateInToday(date) {
            let hour = date.formatted(.dateTime.hour().minute())
            subtitle = String(localized: "notif.date.subtitle.today \(hour)")
        } else {
            subtitle = date.formatted(date: .abbreviated, time: .shortened)
        }

        let content = makeContent(
            title: item.text,
            subtitle: subtitle,
            id: item.id,
            level: .timeSensitive,
            relevance: 1.0
        )

        let trigger: UNNotificationTrigger
        let interval = date.timeIntervalSinceNow

        // Recordatorios próximos → trigger relativo
        if interval > 0 && interval <= 24 * 60 * 60 {
            trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: interval,
                repeats: false
            )
        } else {
            // Fechas lejanas → calendario
            let components = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            )

            trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
        }

        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Location Reminder

    private func scheduleLocation(for item: PikItem) {

        guard
            let lat = item.latitude,
            let lon = item.longitude
        else { return }

        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            radius: 100,
            identifier: item.id.uuidString
        )

        region.notifyOnEntry = true
        region.notifyOnExit = false

        let placeName = item.placeName ?? String(localized: "notif.location.unknown")

        let content = makeContent(
            title: item.text,
            subtitle: String(localized: "notif.location.subtitle \(placeName)"),
            id: item.id,
            level: .timeSensitive,
            relevance: 0.8
        )

        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Remove

    func remove(for item: PikItem) {

        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(
            withIdentifiers: [item.id.uuidString]
        )

        center.removeDeliveredNotifications(
            withIdentifiers: [item.id.uuidString]
        )
    }

    // MARK: - Update

    func update(for item: PikItem) {

        remove(for: item)

        switch item.reminderType ?? .none {

        case .date:
            scheduleDate(for: item)

        case .location:
            scheduleLocation(for: item)

        case .none:
            break
        }

        Task {
            await LiveActivityManager.shared.update(for: item)
        }
    }

    // MARK: - Cancel (archivar / borrar)

    func cancel(for item: PikItem) {
        let id = item.id
        remove(for: item)
        Task { await LiveActivityManager.shared.cancel(id: id) }
    }

    // MARK: - Snooze

    private func snooze(id: String, minutes: Int) {

        guard let uuid = UUID(uuidString: id) else { return }

        Task { @MainActor in
            do {
                let container = try ModelContainer(for: PikItem.self)
                let context = ModelContext(container)

                let descriptor = FetchDescriptor<PikItem>(
                    predicate: #Predicate<PikItem> { item in
                        item.id == uuid
                    }
                )

                guard let item = try context.fetch(descriptor).first else { return }

                item.reminderType = .date
                item.remindAt = Date().addingTimeInterval(TimeInterval(minutes * 60))
                try context.save()

                // Borra la notificación entregada, reprograma y actualiza la Live Activity
                self.update(for: item)

            } catch {
                print("❌ Error posponiendo:", error)
            }
        }
    }
    
//    private func reschedule(id: String, minutes: Int) {
//
//        guard let uuid = UUID(uuidString: id) else { return }
//
//        let center = UNUserNotificationCenter.current()
//
//        center.getDeliveredNotifications { [weak self] notifications in
//
//            guard let self,
//                  let delivered = notifications.first(where: {
//                      $0.request.identifier == id
//                  }) else { return }
//
//            center.removeDeliveredNotifications(withIdentifiers: [id])
//
//            let content = self.makeContent(
//                title: delivered.request.content.title,
//                subtitle: String(localized: "notif.snoozed"),
//                id: uuid,
//                level: .timeSensitive
//            )
//
//            let trigger = UNTimeIntervalNotificationTrigger(
//                timeInterval: TimeInterval(minutes * 60),
//                repeats: false
//            )
//
//            let request = UNNotificationRequest(
//                identifier: id,
//                content: content,
//                trigger: trigger
//            )
//
//            center.add(request)
//        }
//    }

    // MARK: - Complete

    private func markAsCompleted(_ id: String) {

        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])

        guard let uuid = UUID(uuidString: id) else { return }

        do {
            let container = try ModelContainer(for: PikItem.self)
            let context = ModelContext(container)

            let descriptor = FetchDescriptor<PikItem>(
                predicate: #Predicate<PikItem> { item in
                    item.id == uuid
                }
            )

            if let item = try context.fetch(descriptor).first {
                item.status = .completed
                try context.save()
            }

        } catch {
            print("❌ Error marcando como completado:", error)
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .pikCompleted,
                object: uuid
            )
        }

        Task {
            await LiveActivityManager.shared.end(id: uuid)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension NotificationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        print("📍 Location permission: \(manager.authorizationStatus.rawValue)")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {

        return [.banner, .sound, .badge]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {

        let id = response.notification.request.identifier

        switch response.actionIdentifier {

        case ActionID.done:
            markAsCompleted(id)

        case ActionID.snooze15:
            snooze(id: id, minutes: 15)

            //reschedule(id: id, minutes: 15)

        case ActionID.snooze60:
            snooze(id: id, minutes: 60)

            //reschedule(id: id, minutes: 60)

        case UNNotificationDefaultActionIdentifier:
            // Tap en la notificación → deep link al item
            if let idString = response.notification.request.content.userInfo["itemID"] as? String,
               let uuid = UUID(uuidString: idString) {
                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .pikOpenItem,
                        object: uuid
                    )
                }
            }

        default:
            break
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let pikCompleted = Notification.Name("pikCompleted")
    static let pikOpenItem = Notification.Name("pikOpenItem")
}

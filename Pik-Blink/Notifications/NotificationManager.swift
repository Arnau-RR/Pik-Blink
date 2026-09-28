//
//  NotificationManager.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

//import Foundation
//import UserNotifications
//import CoreLocation

import Foundation
import UserNotifications
import CoreLocation
import SwiftData
import UIKit

final class NotificationManager: NSObject {

    static let shared = NotificationManager()

    private let locationManager = CLLocationManager()

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

        let done = UNNotificationAction(
            identifier: "DONE",
            title: "Completar",
            options: [.foreground]
        )

        let snooze = UNNotificationAction(
            identifier: "SNOOZE_15",
            title: "Posponer 15 min"
        )

        let category = UNNotificationCategory(
            identifier: "PIK_REMINDER",
            actions: [done, snooze],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }

    // MARK: - Public

    func schedule(for item: PikItem) {
        
        Task {
            await LiveActivityManager.shared.start(for: item)
        }
        
        switch item.reminderType {
        case .date:
            scheduleDate(for: item)

        case .location:
            scheduleLocation(for: item)

        case .none:
            break

        case .some(.none):
            break
        }
    }

    // MARK: - Date Reminder

    private func scheduleDate(for item: PikItem) {

        guard let date = item.remindAt else { return }

        let formattedHour = date.formatted(.dateTime.hour().minute())

        let content = UNMutableNotificationContent()
        content.title = item.text
        content.subtitle = "Hoy · \(formattedHour)"
        content.body = ""
        content.sound = .default
        content.categoryIdentifier = "PIK_REMINDER"
        content.threadIdentifier = "pik-reminders"
        content.summaryArgument = "Pik"
        content.interruptionLevel = .timeSensitive

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
    
//    private func scheduleDate(for item: PikItem) {
//
//        guard let date = item.remindAt else { return }
//
//        let formattedHour = date.formatted(
//            .dateTime.hour().minute()
//        )
//
//        let content = UNMutableNotificationContent()
//
//        content.title = item.text
//        content.subtitle = "Hoy · \(formattedHour)"
//        content.body = ""
//
//        content.sound = .default
//        content.categoryIdentifier = "PIK_REMINDER"
//        content.threadIdentifier = "pik-reminders"
//        content.summaryArgument = "Pik"
//        content.interruptionLevel = .timeSensitive
//
//        let components = Calendar.current.dateComponents(
//            [.year, .month, .day, .hour, .minute],
//            from: date
//        )
//
//        let trigger = UNCalendarNotificationTrigger(
//            dateMatching: components,
//            repeats: false
//        )
//
//        let request = UNNotificationRequest(
//            identifier: item.id.uuidString,
//            content: content,
//            trigger: trigger
//        )
//
//        UNUserNotificationCenter.current().add(request)
//    }

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

        let content = UNMutableNotificationContent()

        content.title = item.text
        let placeName = item.placeName ?? "la ubicación"
        content.subtitle = "Cuando llegues a \(placeName)"
        content.body = ""

        content.sound = .default
        content.categoryIdentifier = "PIK_REMINDER"
        content.threadIdentifier = "pik-reminders"
        content.summaryArgument = "Pik"
        content.interruptionLevel = .active

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

    // MARK: - Snooze

    private func reschedule(id: String, minutes: Int) {

        let center = UNUserNotificationCenter.current()

        center.getDeliveredNotifications { notifications in

            guard let delivered = notifications.first(where: {
                $0.request.identifier == id
            }) else { return }

            center.removeDeliveredNotifications(withIdentifiers: [id])

            let content = UNMutableNotificationContent()

            content.title = delivered.request.content.title
            content.subtitle = "En \(minutes) min"
            content.body = ""

            content.sound = .default
            content.categoryIdentifier = "PIK_REMINDER"
            content.threadIdentifier = "pik-reminders"
            content.summaryArgument = "Pik"
            content.interruptionLevel = .timeSensitive

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(minutes * 60),
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )

            center.add(request)
        }
    }

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
    
    func cancel(for item: PikItem) {
        remove(for: item)
        Task { await LiveActivityManager.shared.cancel(id: item.id) }
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

        case "DONE":
            markAsCompleted(id)

        case "SNOOZE_15":
            reschedule(id: id, minutes: 15)

        default:
            break
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let pikCompleted = Notification.Name("pikCompleted")
}

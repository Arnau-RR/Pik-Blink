//
//  LiveActivityManager.swift
//  Pik-Blink
//
//  Created by Arnau on 28/09/2026.
//

import ActivityKit
import Foundation

final class LiveActivityManager {

    static let shared = LiveActivityManager()

    private init() {}

    // MARK: Start
    @MainActor
    func start(for item: PikItem) {

        guard item.status == .pending else {
            return
        }

        guard (item.reminderType ?? .none) == .date,
              let reminderDate = item.remindAt else {
            return
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities disabled")
            return
        }

        let now = Date()
        let liveActivityStart = reminderDate.addingTimeInterval(-60 * 60)

        // Si ya estamos dentro de la última hora,
        // empezamos la Live Activity inmediatamente.
        let startDate = max(now, liveActivityStart)

        // Evita duplicados
        if Activity<PikLiveActivityAttributes>.activities.contains(where: {
            $0.attributes.id == item.id
        }) {
            print("ℹ️ Live Activity already exists")
            return
        }

        let state = PikLiveActivityAttributes.ContentState(
            title: item.text,
            reminderType: item.reminderType ?? .none,
            reminderDate: item.remindAt,
            placeName: item.placeName,
            isCompleted: false
        )

        let content = ActivityContent(
            state: state,
            staleDate: reminderDate,
            relevanceScore: score(for: state)
        )

        do {

            // Si la Live Activity debe empezar ahora
            if startDate <= now {

                let activity = try Activity.request(
                    attributes: PikLiveActivityAttributes(id: item.id),
                    content: content,
                    pushType: nil
                )

                print("✅ Live Activity started:", activity.id)

            } else {

                // Si todavía falta más de 1 hora,
                // la dejamos programada.
                let alertConfiguration = AlertConfiguration(
                    title: "Pik Blink",
                    body: "Your reminder is coming up",
                    sound: .default
                )

                let activity = try Activity.request(
                    attributes: PikLiveActivityAttributes(id: item.id),
                    content: content,
                    pushType: nil,
                    style: .standard,
                    alertConfiguration: alertConfiguration,
                    start: startDate
                )

                print("⏳ Live Activity scheduled:", activity.id)
                print("⏰ Starts at:", startDate)
            }

        } catch {
            print("❌ Activity error:", error)
        }
    }
//    func start(for item: PikItem) {
//
//        print("🚀 Starting Live Activity")
//
//        if Activity<PikLiveActivityAttributes>.activities.contains(where: {
//               $0.attributes.id == item.id
//           }) {
//               return
//           }
//        
//        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
//            print("❌ Live Activities disabled")
//            return
//        }
//
//        do {
//            let attributes = PikLiveActivityAttributes(id: item.id)
//
//            let state = PikLiveActivityAttributes.ContentState(
//                title: item.text,
//                reminderType: item.reminderType ?? .none,
//                reminderDate: item.remindAt,
//                placeName: item.placeName,
//                isCompleted: false
//            )
//
//            let content = ActivityContent(
//                state: state,
//                staleDate: nil,
//
//               // staleDate: item.remindAt,
//                relevanceScore: score(for: state)
//            )
//
//            let activity = try Activity.request(
//                attributes: attributes,
//                content: content
//            )
//
//            print("✅ Activity created:", activity.id)
//
//        } catch {
//            print("❌ Activity error:", error)
//        }
//    }
    
    
    @MainActor
    func refreshScores() async {
        for activity in Activity<PikLiveActivityAttributes>.activities {
            let state = activity.content.state
            let content = ActivityContent(
                state: state,
                staleDate: activity.content.staleDate,
                relevanceScore: score(for: state)
            )
            await activity.update(content)
        }
    }
    
    func score(for state: PikLiveActivityAttributes.ContentState) -> Double {
        guard state.reminderType == .date,
              let date = state.reminderDate else { return 0 }

        let remaining = max(date.timeIntervalSinceNow, 0)
        // Cuanto menos tiempo queda, más puntuación (máx 1000, mín ~100)
        return 100 + 900 / (1 + remaining / 60)
    }
    
//    func start(for item: PikItem) {
//
//        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
//
//        guard item.status == .pending else { return }
//
//        let state = PikLiveActivityAttributes.ContentState(
//            title: item.text,
//            reminderType: item.reminderType ?? .none,
//            reminderDate: item.remindAt,
//            placeName: item.placeName,
//            isCompleted: false
//        )
//
//        let attributes = PikLiveActivityAttributes(id: item.id)
//
//        do {
//            _ = try Activity.request(
//                attributes: attributes,
//                content: .init(state: state, staleDate: item.remindAt)
//            )
//        } catch {
//            print("❌ Live Activity:", error)
//        }
//    }

    // MARK: Update
    @MainActor
    func update(for item: PikItem) async {

        // Primero eliminamos cualquier Live Activity
        // existente para este recordatorio.
        await cancel(id: item.id)

        guard item.status == .pending,
              (item.reminderType ?? .none) == .date,
              let reminderDate = item.remindAt,
              reminderDate > .now
        else {
            return
        }

        // La volvemos a crear/programar con la nueva fecha.
        start(for: item)
    }
//    func update(for item: PikItem) async {
//
//        guard item.status == .pending,
//              (item.reminderType ?? .none) != .none,
//              (item.remindAt ?? .distantFuture) > .now
//        else {
//            await cancel(id: item.id)
//            return
//        }
//
//        let state = PikLiveActivityAttributes.ContentState(
//            title: item.text,
//            reminderType: item.reminderType ?? .none,
//            reminderDate: item.remindAt,
//            placeName: item.placeName,
//            isCompleted: false
//        )
//
//        let content = ActivityContent(
//            state: state,
//            staleDate: nil,
//
//            //staleDate: item.remindAt,
//            relevanceScore: score(for: state)
//        )
//
//        if let activity = activity(for: item.id) {
//            await activity.update(content)
//            return
//        }
//
//        // Si no existe todavía, usamos la misma lógica de
//        // programación que al crear el recordatorio.
//        start(for: item)
//        
////        if let activity = activity(for: item.id) {
////            await activity.update(content)
////            return
////        }
////
////        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
////
////        do {
////            _ = try Activity.request(
////                attributes: PikLiveActivityAttributes(id: item.id),
////                content: content
////            )
////        } catch {
////            print("❌ Activity error:", error)
////        }
//    }

    // MARK: End
    @MainActor
    func end(id: UUID) async {
        guard let activity = activity(for: id) else { return }

        var finalState = activity.content.state
        finalState.isCompleted = true

        await activity.end(
            ActivityContent(state: finalState, staleDate: nil),
            dismissalPolicy: .after(.now + 5)
        )
    }
    
    @MainActor
    func cancel(id: UUID) async {
        guard let activity = activity(for: id) else { return }
        await activity.end(nil, dismissalPolicy: .immediate)
    }
    
    @MainActor
    func endExpired() async {
        for activity in Activity<PikLiveActivityAttributes>.activities {
            if let date = activity.content.state.reminderDate, date < .now {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
//    func end(id: UUID) async {
//
//        guard let activity = activity(for: id) else { return }
//
//        let finalState = activity.content.state
//        await activity.end(
//            ActivityContent(
//                state: finalState,
//                staleDate: nil
//            ),
//            dismissalPolicy: .immediate
//        )
//    }

    // MARK: Helpers

    private func activity(for id: UUID)
        -> Activity<PikLiveActivityAttributes>? {

        Activity<PikLiveActivityAttributes>.activities.first {
            $0.attributes.id == id
        }
    }
}

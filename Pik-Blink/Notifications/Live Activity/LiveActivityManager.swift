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

        print("🚀 Starting Live Activity")

        if Activity<PikLiveActivityAttributes>.activities.contains(where: {
               $0.attributes.id == item.id
           }) {
               return
           }
        
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities disabled")
            return
        }

        do {
            let attributes = PikLiveActivityAttributes(id: item.id)

            let state = PikLiveActivityAttributes.ContentState(
                title: item.text,
                reminderType: item.reminderType ?? .none,
                reminderDate: item.remindAt,
                placeName: item.placeName,
                isCompleted: false
            )

            let content = ActivityContent(
                state: state,
                staleDate: item.remindAt,
                relevanceScore: score(for: state)
            )

            let activity = try Activity.request(
                attributes: attributes,
                content: content
            )

            print("✅ Activity created:", activity.id)

        } catch {
            print("❌ Activity error:", error)
        }
    }
    
    
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

        guard item.status == .pending,
              (item.reminderType ?? .none) != .none,
              (item.remindAt ?? .distantFuture) > .now
        else {
            await cancel(id: item.id)
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
            staleDate: item.remindAt,
            relevanceScore: score(for: state)
        )

        if let activity = activity(for: item.id) {
            await activity.update(content)
            return
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        do {
            _ = try Activity.request(
                attributes: PikLiveActivityAttributes(id: item.id),
                content: content
            )
        } catch {
            print("❌ Activity error:", error)
        }
    }

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

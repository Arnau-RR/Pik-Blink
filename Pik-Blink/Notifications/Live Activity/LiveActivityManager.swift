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
                relevanceScore: 100
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

        guard let activity = activity(for: item.id) else { return }

        let state = PikLiveActivityAttributes.ContentState(
            title: item.text,
            reminderType: item.reminderType ?? .none,
            reminderDate: item.remindAt,
            placeName: item.placeName,
            isCompleted: item.status == .completed
        )

        await activity.update(
            .init(state: state, staleDate: item.remindAt)
        )
    }

    // MARK: End
    @MainActor
    func end(id: UUID) async {

        guard let activity = activity(for: id) else { return }

        let finalState = activity.content.state
        await activity.end(
            ActivityContent(
                state: finalState,
                staleDate: nil
            ),
            dismissalPolicy: .immediate
        )
    }

    // MARK: Helpers

    private func activity(for id: UUID)
        -> Activity<PikLiveActivityAttributes>? {

        Activity<PikLiveActivityAttributes>.activities.first {
            $0.attributes.id == id
        }
    }
}

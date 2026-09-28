//
//  PikLiveActivityAttributes.swift
//  Pik-Blink
//
//  Created by Arnau on 28/09/2026.
//

import ActivityKit
import Foundation

nonisolated struct PikLiveActivityAttributes: ActivityAttributes, Sendable {

    nonisolated struct ContentState: Codable, Hashable, Sendable {
        var title: String
        var reminderType: ReminderType
        var reminderDate: Date?
        var placeName: String?
        var isCompleted: Bool
    }

    let id: UUID
}

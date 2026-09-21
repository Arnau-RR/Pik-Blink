//
//  PikItem.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//


import Foundation
import SwiftData

// MARK: - Pik Item

@Model
final class PikItem {

    @Attribute(.unique)
    var id: UUID

    // MARK: Content

    /// Main text shown in the UI.
    var text: String

    /// Original speech transcription (optional).
    var transcription: String?

    /// Local path to the recorded audio file.
    var audioPath: String?

    // MARK: Dates

    /// Creation date.
    var createdAt: Date

    /// Optional reminder date.
    var remindAt: Date?

    // MARK: State

    var status: PikStatus

    /// Whether the item was created by text or voice.
    var source: PikSource

    // MARK: Init

    init(
        text: String,
        transcription: String? = nil,
        audioPath: String? = nil,
        remindAt: Date? = nil,
        source: PikSource = .text
    ) {
        self.id = UUID()
        self.text = text
        self.transcription = transcription
        self.audioPath = audioPath
        self.createdAt = .now
        self.remindAt = remindAt
        self.status = .pending
        self.source = source
    }
}

// MARK: - Status

enum PikStatus: Int, Codable {
    case pending
    case completed
    case expired
}

// MARK: - Source

enum PikSource: Int, Codable {
    case text
    case voice
}

// MARK: - Computed Properties

extension PikItem {

    var hasReminder: Bool {
        remindAt != nil
    }

    var hasAudio: Bool {
        audioPath != nil
    }

    var isVoice: Bool {
        source == .voice
    }

    var isCompleted: Bool {
        status == .completed
    }

    var isOverdue: Bool {
        guard let remindAt else { return false }

        return remindAt < Date() && status == .pending
    }

    var displayText: String {
        transcription ?? text
    }
}

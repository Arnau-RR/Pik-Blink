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

    // MARK: Media

    /// Local path to the attached image.
    var imagePath: String?

    /// Local path to the recorded audio.
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
        imagePath: String? = nil,
        audioPath: String? = nil,
        remindAt: Date? = nil,
        source: PikSource = .text
    ) {
        self.id = UUID()
        self.text = text
        self.transcription = transcription
        self.imagePath = imagePath
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
    case archived
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

    var hasImage: Bool {
        imagePath != nil
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
        return remindAt < .now && status == .pending
    }

    var displayText: String {
        transcription ?? text
    }
}

// MARK: - Mock Data

extension PikItem {

    static var mockList: [PikItem] {

        let calendar = Calendar.current

        // MARK: Hoy

        let today1 = PikItem(
            text: "Comprar café"
        )

        let today2 = PikItem(
            text: "Llamar a Marta",
            transcription: "Llamar a Marta al salir del trabajo",
            audioPath: "/mock/audio/marta.m4a",
            source: .voice
        )

        let today3 = PikItem(
            text: "Guardar inspiración del salón",
            imagePath: "/mock/images/salon.jpg"
        )

        let today4 = PikItem(
            text: "Idea para la app",
            transcription: "Añadir animación al completar tareas",
            imagePath: "/mock/images/wireframe.jpg",
            audioPath: "/mock/audio/idea.m4a",
            source: .voice
        )

        // MARK: Ayer

        let yesterday1 = PikItem(
            text: "Enviar presupuesto"
        )

        let yesterday2 = PikItem(
            text: "Reservar restaurante",
            imagePath: "/mock/images/restaurant.jpg"
        )

        let yesterday3 = PikItem(
            text: "Hacer la compra"
        )

        let yesterday4 = PikItem(
            text: "Entrevista con Apple",
            audioPath: "/mock/audio/interview.m4a",
            source: .voice
        )

        // Cambiar fecha a ayer
        [yesterday1, yesterday2, yesterday3, yesterday4].forEach {
            $0.createdAt = calendar.date(byAdding: .day, value: -1, to: .now)!
        }

        // MARK: Antes de ayer

        let older1 = PikItem(
            text: "Renovar DNI"
        )

        let older2 = PikItem(
            text: "Pagar factura de la luz",
            imagePath: "/mock/images/factura.jpg"
        )

        [older1, older2].forEach {
            $0.createdAt = calendar.date(byAdding: .day, value: -2, to: .now)!
        }

        return [
            today1, today2, today3, today4,
            yesterday1, yesterday2, yesterday3, yesterday4,
            older1, older2
        ]
    }
}

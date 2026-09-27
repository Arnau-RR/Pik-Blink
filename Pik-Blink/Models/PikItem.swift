//
//  PikItem.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Foundation
import SwiftData
import CoreLocation

enum QuickReminderSelection: Int, Codable {
    case thirtyMinutes
    case oneHour
    case twoHours
    case custom
}

enum PlaceSelection: Int, Codable {
    case search
    case favorite
}

// MARK: - Pik Item

@Model
final class PikItem {

    @Attribute(.unique)
    var id: UUID

    // MARK: Content

    var text: String
    var transcription: String?

    // MARK: Media

    var imagePath: String?
    var audioPath: String?

    // MARK: Dates

    var createdAt: Date

    // MARK: Reminder

    var reminderType: ReminderType?
    var quickReminder: QuickReminderSelection?
    var remindAt: Date?

    // MARK: Location

    var placeSelection: PlaceSelection?
    var placeName: String?
    var placeAddress: String?
    var latitude: Double?
    var longitude: Double?

    // MARK: State

    var status: PikStatus
    var source: PikSource

    // MARK: Init

    init(
        text: String,
        transcription: String? = nil,
        imagePath: String? = nil,
        audioPath: String? = nil,
        reminderType: ReminderType? = ReminderType.none,
        quickReminder: QuickReminderSelection? = nil,
        remindAt: Date? = nil,
        placeSelection: PlaceSelection? = nil,
        placeName: String? = nil,
        placeAddress: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        source: PikSource = .text,
        status: PikStatus = .pending
    ) {
        self.id = UUID()
        self.text = text
        self.transcription = transcription
        self.imagePath = imagePath
        self.audioPath = audioPath
        self.createdAt = .now

        self.reminderType = reminderType
        self.quickReminder = quickReminder
        self.remindAt = remindAt

        self.placeSelection = placeSelection
        self.placeName = placeName
        self.placeAddress = placeAddress
        self.latitude = latitude
        self.longitude = longitude

        self.source = source
        self.status = status
    }
}

// MARK: - Reminder Type

enum ReminderType: Int, Codable {
    case none
    case date
    case location
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

// MARK: - Computed

extension PikItem {

    var hasReminder: Bool {
        (reminderType ?? .none) != .none
    }

    var hasLocation: Bool {
        reminderType == .location
    }

    var hasDateReminder: Bool {
        reminderType == .date
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
        guard reminderType == .date,
              let remindAt else { return false }

        return remindAt < .now && status == .pending
    }

    var displayText: String {
        transcription ?? text
    }

    var location: SelectedPlace? {
        guard reminderType == .location,
              let name = placeName,
              let address = placeAddress,
              let lat = latitude,
              let lon = longitude
        else { return nil }

        return SelectedPlace(
            name: name,
            address: address,
            coordinate: CLLocationCoordinate2D(
                latitude: lat,
                longitude: lon
            )
        )
    }
}

// MARK: - Mock Data

extension PikItem {

    static var mockList: [PikItem] {

        let calendar = Calendar.current

        let today1 = PikItem(text: "Comprar café")

        let today2 = PikItem(
            text: "Llamar a Marta",
            transcription: "Llamar a Marta al salir del trabajo",
            audioPath: "/mock/audio/marta.m4a",
            reminderType: .date,
            remindAt: calendar.date(byAdding: .hour, value: 2, to: .now),
            source: .voice
        )

        let today3 = PikItem(
            text: "Guardar inspiración del salón",
            imagePath: "/mock/images/salon.jpg",
            reminderType: .location,
            placeName: "Sant Andreu de Llavaneres",
            placeAddress: "Barcelona, España",
            latitude: 41.57,
            longitude: 2.48
        )

        let today4 = PikItem(
            text: "Idea para la app",
            transcription: "Añadir animación al completar tareas",
            imagePath: "/mock/images/wireframe.jpg",
            audioPath: "/mock/audio/idea.m4a",
            source: .voice
        )

        let yesterday1 = PikItem(text: "Enviar presupuesto")
        let yesterday2 = PikItem(text: "Reservar restaurante")
        let yesterday3 = PikItem(text: "Hacer la compra")
        let yesterday4 = PikItem(text: "Entrevista con Apple", source: .voice)

        [yesterday1, yesterday2, yesterday3, yesterday4].forEach {
            $0.createdAt = calendar.date(byAdding: .day, value: -1, to: .now)!
        }

        let older1 = PikItem(text: "Renovar DNI")
        let older2 = PikItem(text: "Pagar factura de la luz")

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

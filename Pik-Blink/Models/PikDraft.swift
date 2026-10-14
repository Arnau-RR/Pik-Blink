//
//  PikDraft.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import Foundation
import SwiftData

// We implement another Model to prevent to add into the DB information incompleted

@Model
final class PikDraft {

    // CloudKit no soporta @Attribute(.unique), por eso se ha quitado.
    var id: UUID = UUID()

    var text: String = ""

    var reminderType: ReminderType = ReminderType.none
    var quickReminder: QuickReminderSelection?
    var remindAt: Date?

    var placeSelection: PlaceSelection?
    var placeLabel: String?
    var placeName: String?
    var placeAddress: String?

    var latitude: Double?
    var longitude: Double?

    var audioPath: String?

    var isPickingCustomDate: Bool = false
    var isPickingLocation: Bool = false
    var locationName: String?

    init() {
        self.id = UUID()
        self.text = ""

        self.reminderType = .none
        self.quickReminder = nil
        self.remindAt = nil

        self.placeSelection = nil
        self.placeLabel = nil
        self.placeName = nil
        self.placeAddress = nil
        self.latitude = nil
        self.longitude = nil

        self.audioPath = nil

        self.isPickingCustomDate = false
        self.isPickingLocation = false
        self.locationName = nil
    }
}

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

    @Attribute(.unique)
    var id: UUID

    var text: String

    var reminderType: ReminderType
    var remindAt: Date?

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
        self.remindAt = nil

        self.placeName = nil
        self.placeAddress = nil
        self.latitude = nil
        self.longitude = nil

        self.audioPath = nil
    }
}

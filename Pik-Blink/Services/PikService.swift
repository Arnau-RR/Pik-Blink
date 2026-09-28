//
//  PikService.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//


import SwiftData

@MainActor
struct PikService {

    static func create(
        from draft: PikDraft,
        in context: ModelContext
    ) throws {

        let item = PikItem(
            text: draft.text,
            transcription: draft.audioPath != nil ? draft.text : nil,
            audioPath: draft.audioPath,

            reminderType: draft.reminderType,
            remindAt: draft.remindAt,

            placeName: draft.placeName,
            placeAddress: draft.placeAddress,
            latitude: draft.latitude,
            longitude: draft.longitude,

            source: draft.audioPath == nil ? .text : .voice,
            status: .pending
        )

        context.insert(item)
        try context.save()

        if item.reminderType == .location {
            NotificationManager.shared.requestLocationPermission()
        }

        NotificationManager.shared.schedule(for: item)
    }
}
//
//  SaveDraftIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import AppIntents
import SwiftData
import WidgetKit

struct SaveDraftIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Save Pik"
    
    @Dependency
    private var modelContainer: ModelContainer
    
    @Parameter(title: "Draft")
    var draft: PikDraftEntity
    
    init() {}
    
    init(draft: PikDraftEntity) {
        self.draft = draft
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let context = ModelContext(modelContainer)
        
        let draftID = draft.id
        
        let descriptor = FetchDescriptor<PikDraft>(
            predicate: #Predicate<PikDraft> {
                $0.id == draftID
            }
        )
        
        guard let model = try context.fetch(descriptor).first else {
            return .result(
                dialog: IntentDialog("No se encontró el borrador")
            )
        }
        
        let item = PikItem(
            text: model.text.trimmingCharacters(in: .whitespacesAndNewlines),
            transcription: model.audioPath != nil ? model.text : nil,
            audioPath: model.audioPath,
            reminderType: model.reminderType,
            remindAt: model.reminderType == .date ? model.remindAt : nil,
            placeName: model.reminderType == .location ? model.placeName : nil,
            placeAddress: model.reminderType == .location ? model.placeAddress : nil,
            latitude: model.reminderType == .location ? model.latitude : nil,
            longitude: model.reminderType == .location ? model.longitude : nil,
            source: model.audioPath == nil ? .text : .voice,
            status: .pending
        )
        
        context.insert(item)
        
        context.delete(model)
        
        try context.save()
        
        let notifications = NotificationManager.shared

        context.insert(item)
        context.delete(model)
        try context.save()

        if item.reminderType == .location {
            notifications.requestLocationPermission()
        }

        notifications.schedule(for: item)
        
        NotificationCenter.default.post(name: .pikCreated, object: nil)
        
        WidgetCenter.shared.reloadTimelines(ofKind: "PikWidget")
        
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName("com.arnaurivas.PikBlink.reload" as CFString),
            nil,
            nil,
            true
        )

        return .result(
            dialog: IntentDialog("Pik guardado")
        )
    }
}

extension Notification.Name {
    static let pikCreated = Notification.Name("pikCreated")
}

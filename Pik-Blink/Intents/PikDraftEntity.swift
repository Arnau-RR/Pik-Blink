//
//  PikDraftEntity.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import AppIntents

enum ReminderChoice: String, AppEnum {

    case none
    case time
    case location

    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Reminder choice"
    )

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .none: "None",
        .time: "When",
        .location: "Where"
    ]
}

struct PikDraftEntity: AppEntity {

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Pik Draft"
    )
    
    static let defaultQuery = PikDraftQuery()

    let id: UUID
    let text: String
    
    var audioPath: String?
    var transcription: String?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral:
                text.isEmpty ? "New Pik" : text
            )
        )
    }
}

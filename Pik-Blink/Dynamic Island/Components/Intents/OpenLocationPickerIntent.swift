//
//  OpenLocationPickerIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import AppIntents

struct OpenLocationPickerIntent: AppIntent {

    static let title: LocalizedStringResource = "app.intent.open.location.picker.title"
    static var isDiscoverable: Bool = false

    @Parameter(title: "app.intent.open.location.picker.parameter.draft")
    var draft: PikDraftEntity

    init() {}

    init(draft: PikDraftEntity) {
        self.draft = draft
    }

    func perform() async throws -> some IntentResult {

        // Lo conectaremos con la app en el siguiente paso
        return .result()
    }
}

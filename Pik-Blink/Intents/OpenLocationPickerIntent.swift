//
//  OpenLocationPickerIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import AppIntents

struct OpenLocationPickerIntent: AppIntent {

    static let title: LocalizedStringResource = "Choose another place"

    @Parameter(title: "Draft")
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

//
//  CompletePikIntent.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import AppIntents
import SwiftData
import WidgetKit

struct CompletePikIntent: AppIntent {

    static var title: LocalizedStringResource = "Complete Pik"

    @Parameter(title: "Pik ID")
    var id: String

    init() {}

    init(id: UUID) {
        self.id = id.uuidString
    }

    func perform() async throws -> some IntentResult {

        let schema = Schema([
            PikItem.self,
            PikDraft.self,
            FavoritePlace.self
        ])

        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.arnaurivas.PikBlink")!
            .appendingPathComponent("Pik.sqlite")

        let configuration = ModelConfiguration(schema: schema, url: url)
        let container = try ModelContainer(for: schema, configurations: configuration)
        let context = ModelContext(container)

        let items = try context.fetch(FetchDescriptor<PikItem>())

        if let pik = items.first(where: { $0.id.uuidString == id }) {
            pik.status = .completed
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "PikWidget")
        }

        return .result()
    }
}

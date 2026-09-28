//
//  PikWidget.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import WidgetKit
import SwiftUI

struct PikWidget: Widget {

    let kind = "PikWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: PikProvider()
        ) { entry in
            PikWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(LocalizedStringResource("widget.configuration.display.name"))
        .description(LocalizedStringResource("widget.configuration.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

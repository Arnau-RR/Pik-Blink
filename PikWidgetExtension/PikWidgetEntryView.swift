//
//  PikWidgetEntryView.swift
//  PikWidgetExtension
//

import SwiftUI
import WidgetKit

struct PikWidgetEntryView: View {

    let entry: PikEntry

    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    private var isDark: Bool { colorScheme == .dark }

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget

        case .systemMedium:
            mediumWidget

        default:
            smallWidget
        }
    }
}

// MARK: - Small
private extension PikWidgetEntryView {

    var smallWidget: some View {
        SmallWidgetView()
            .containerBackground(Color(.systemBackground), for: .widget)
            .widgetURL(URL(string: "pikblink://new"))
    }
}

// MARK: - Medium
private extension PikWidgetEntryView {

    var mediumWidget: some View {

        MediumWidgetView(entry: entry)
            .containerBackground(Color(.systemBackground), for: .widget)
            .widgetURL(URL(string: "pikblink://list"))
    }
}

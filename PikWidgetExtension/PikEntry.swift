//
//  PikEntry.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//


import WidgetKit
import AppIntents

struct PikEntry: TimelineEntry {
    let date: Date
}

struct PikProvider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> PikEntry {
        PikEntry(date: .now)
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> PikEntry {
        PikEntry(date: .now)
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<PikEntry> {
        Timeline(
            entries: [PikEntry(date: .now)],
            policy: .never
        )
    }
}
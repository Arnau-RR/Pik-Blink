//
//  QuickReminderRow.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

enum QuickReminderOption: String, AppEnum {

    case today
    case tonight
    case tomorrow
    case custom

    static let typeDisplayRepresentation =
        TypeDisplayRepresentation(name: "Quick Reminder")

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .today: "Today",
        .tonight: "Tonight",
        .tomorrow: "Tomorrow",
        .custom: "Custom"
    ]
}

struct QuickReminderRow<I: AppIntent>: View {

    let title: String
    let subtitle: String
    let icon: String
    let intent: I

    var body: some View {

        Button(intent: intent) {

            HStack(spacing: 14) {

                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

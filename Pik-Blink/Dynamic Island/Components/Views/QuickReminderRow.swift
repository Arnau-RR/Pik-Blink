//
//  QuickReminderRow.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

enum QuickReminderOption: String, AppEnum {
    case thirtyMinutes
    case oneHour
    case twoHours
    case custom

    static let typeDisplayRepresentation =
        TypeDisplayRepresentation(name: "quick.reminder.type.display")

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .thirtyMinutes: DisplayRepresentation(title: LocalizedStringResource("quick.reminder.option.thirty.minutes")),
        .oneHour: DisplayRepresentation(title: LocalizedStringResource("quick.reminder.option.one.hour")),
        .twoHours: DisplayRepresentation(title: LocalizedStringResource("quick.reminder.option.two.hours")),
        .custom: DisplayRepresentation(title: LocalizedStringResource("quick.reminder.option.custom"))
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

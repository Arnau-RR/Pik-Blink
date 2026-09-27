//
//  ReminderSummaryView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

struct ReminderSummaryView: View {

    let draft: PikDraftEntity
    let date: Date

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "calendar.circle.fill")
                .foregroundStyle(.blue)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {

                Text(String(localized: "reminder.summary.view.title"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(date.formatted(
                    .dateTime
                        .weekday(.wide)
                        .day()
                        .month()
                        .hour()
                        .minute()
                ))
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            }

            Spacer(minLength: 8)

            Button(intent: SetReminderChoiceIntent(
                draft: draft,
                choice: .none
            )) {
                Text(String(localized: "reminder.summary.view.change.button"))
                    .font(.caption.weight(.medium))
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

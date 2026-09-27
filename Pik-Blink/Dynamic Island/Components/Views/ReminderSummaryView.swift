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

                Text("Reminder")
                    .font(.caption)
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
                
                Button(intent: SetReminderChoiceIntent(
                    draft: draft,
                    choice: .none
                )) {
                    Text("Canvia")
                }
                .buttonStyle(.borderless)
            }

            Spacer()
        }
        .padding(14)
        .background(.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

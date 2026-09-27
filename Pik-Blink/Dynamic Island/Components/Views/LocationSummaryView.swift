//
//  LocationSummaryView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

struct LocationSummaryView: View {

    let draft: PikDraftEntity
    let label: String
    let address: String

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "location.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {

                Text(String(localized: "location.summary.title"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(label)
                    .font(.subheadline.weight(.medium))

                Button(intent: SetReminderChoiceIntent(
                    draft: draft,
                    choice: .none
                )) {
                    Text(String(localized: "location.summary.change.button"))
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

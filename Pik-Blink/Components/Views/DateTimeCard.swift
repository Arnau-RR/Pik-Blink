//
//  DateTimeCard.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI

struct DateTimeCard: View {
    let date: Date?
    let onTap: () -> Void

    private var formattedDate: String {
        guard let date else { return "new.item.date.time.placeholder"}

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {

                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 2) {
                    Text("new.item.date.time.title")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        Color.primary.opacity(0.15),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

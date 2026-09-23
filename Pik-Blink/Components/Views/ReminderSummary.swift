//
//  ReminderSummary.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct ReminderSummary: View {
    let date: Date?

    private var time: String {
        guard let date else { return "" }
        return date.formatted(.dateTime.hour().minute())
    }

    private var day: String {
        guard let date else { return "" }
        return date.formatted(
            .dateTime.weekday(.wide).day().month(.wide)
        )
    }

    private var relative: String {
        guard let date else { return "" }

        let calendar = Calendar.current

        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }

        return ""
    }

    var body: some View {
        if date != nil {
            HStack(spacing: 14) {

                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.12))
                        .frame(width: 42, height: 42)

                    Image(systemName: "clock.fill")
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 2) {

                    HStack(spacing: 8) {
                        Text(time)
                            .font(.title3.weight(.bold))

                        if !relative.isEmpty {
                            Text(relative)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(.blue.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }

                    Text(day)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            }
        }
    }
}

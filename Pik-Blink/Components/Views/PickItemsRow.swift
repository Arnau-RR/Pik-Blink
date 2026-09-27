//
//  PickItemsRow.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct PikItemRow: View {
    let item: PikItem
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Button(action: onToggle) {
                Image(systemName: item.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {

                Text(item.displayText)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                if item.hasDateReminder, let remindAt = item.remindAt {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)

                        Text(
                            Calendar.current.isDateInToday(remindAt)
                            ? remindAt.formatted(.dateTime.hour().minute())
                            : remindAt.formatted(.dateTime.day().month(.abbreviated).hour().minute())
                        )
                        .font(.caption)
                    }
                    .foregroundStyle(.secondary)

                } else if item.hasLocation, let place = item.placeName {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.caption2)

                        Text(place)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    .foregroundStyle(.secondary)
                }
                else {
                    HStack(spacing: 4) {
                        Image(systemName: "bell.slash")
                            .font(.caption2)

                        Text(String(localized: "main.list.item.no.reminder"))
                            .font(.caption)
                    }
                    .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {

                if let path = item.imagePath,
                   let uiImage = UIImage(contentsOfFile: path) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if item.hasAudio {
                    Image(systemName: "mic.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PikItemRow(item: PikItem.mockList.first!) {
    }
}

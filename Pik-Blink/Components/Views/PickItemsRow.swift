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
                    .foregroundStyle(
                        item.isCompleted ? .green : .gray
                    )
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {

                Text(item.displayText)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)

                    Text(item.createdAt, style: .time)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

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
        .padding(.vertical, 8)
    }
}

#Preview{
    PikItemRow(item: PikItem.mockList.first!) {
    }
}

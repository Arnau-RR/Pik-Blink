//
//  PikSectionHeader.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import SwiftUI

struct PikSectionHeader: View {
    let title: String
    let systemImage: String
    let count: Int
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 32, height: 32)

                    Image(systemName: systemImage)
                        .font(.subheadline.weight(.semibold))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)

                    Text("\(count) items")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .textCase(nil)
    }
}

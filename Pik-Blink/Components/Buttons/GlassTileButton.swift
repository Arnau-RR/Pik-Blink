//
//  GlassTile.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct GlassTileButton: View {

    let title: String
    let icon: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .frame(width: 74, height: 74)
            .foregroundStyle(isSelected ? .primary : .secondary)
            .background(
                isSelected
                ? AnyShapeStyle(.thinMaterial)
                : AnyShapeStyle(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                        ? .white.opacity(0.22)
                        : .white.opacity(0.10),
                        lineWidth: 1
                    )
            }
            .opacity(isSelected ? 1 : 0.65)
            .scaleEffect(isSelected ? 1 : 0.96)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

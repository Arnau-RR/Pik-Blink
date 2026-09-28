//
//  GlassTextButton.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct GlassTextButton: View {
    let title: String
    let isSelected: Bool
    let backgroundColor: Color
    var action: () -> Void

    init(
        title: String,
        isSelected: Bool = false,
        backgroundColor: Color = .clear,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.backgroundColor = backgroundColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .padding(.horizontal, 17)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(backgroundColor)
                        .background(isSelected ? .thinMaterial : .ultraThinMaterial)
                        .clipShape(Capsule())
                )
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected ? .white.opacity(0.22) : .white.opacity(0.10),
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

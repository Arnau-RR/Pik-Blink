//
//  GlassIconButton.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct GlassIconButton: View {

    let icon: String
    var isEnabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .background(.ultraThinMaterial)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.white.opacity(0.18), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
        .opacity(isEnabled ? 1.0 : 0.4)
    }
}

#Preview {
    GlassIconButton(icon: "magnifyingglass") {}
}

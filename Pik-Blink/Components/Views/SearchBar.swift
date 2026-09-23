//
//  SearchBar.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var placeholder: String = "Buscar un lloc o adreça..."

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .font(.system(size: 18, weight: .medium))

            TextField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.gray))
                .foregroundColor(.white)
        }
        .padding(.horizontal)
        .frame(height: 42)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        )
    }
}

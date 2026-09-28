//
//  SettingsRow.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct SettingsRow: View {
    let title: LocalizedStringKey
    let icon: String
    var value: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .frame(width: 22)

            Text(title)

            Spacer()

            if let value {
                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

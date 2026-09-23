//
//  ReminderBox.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI

struct ReminderBox<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

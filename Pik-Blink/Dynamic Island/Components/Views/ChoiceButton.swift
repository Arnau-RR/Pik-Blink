//
//  ChoiceButton.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

struct ChoiceButton<I: AppIntent>: View {

    let title: Text
    let icon: String
    let intent: I

    var body: some View {
        Button(intent: intent) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)

                //Text(title)
                title
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(.gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

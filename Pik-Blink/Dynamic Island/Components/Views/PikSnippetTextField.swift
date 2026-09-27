//
//  PikSnippetTextField.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

struct PikSnippetTextField: View {

    let draft: PikDraftEntity
    let text: String

    private let title = String(localized: "snippet.text.field.header.title")
    private let subtitle = String(localized: "snippet.text.field.header.subtitle")
    private let characterLimit = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.headline)
            }

            // Campo
            Button(intent: SetTextIntent(draft: draft)) {
                VStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(String(localized: "snippet.text.field.placeholder"))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 40, alignment: .topLeading)
                    } else {
                        Text(text)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 40, alignment: .topLeading)
                    }
                }
                .padding(14)
                .background(.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            HStack {
                Spacer()
                Text(
                    String(
                        localized: "snippet.text.field.character.counter",
                        defaultValue: "\(text.count)/\(characterLimit) characters"
                    )
                )
                .font(.caption2)
                .foregroundStyle(
                    text.count >= characterLimit ? .red : .secondary
                )
            }
            .padding(.horizontal, 4)
        }
    }
}

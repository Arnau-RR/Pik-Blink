//
//  PikTextField.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct PikTextField: View {
    @Binding var text: String
    let isRecording: Bool

    var onMicTap: () -> Void = {}

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(String(localized: "new.item.textfield.placeholder"))
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }

                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
            }

            Button(action: onMicTap) {
                Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")
                    .font(.title2)
                    .foregroundStyle(isRecording ? .red : .blue)
            }
            .padding(.top, 8)
        }
        .padding(14)
        .frame(minHeight: 96)
        .background(Color(.secondarySystemBackground))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(.separator), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

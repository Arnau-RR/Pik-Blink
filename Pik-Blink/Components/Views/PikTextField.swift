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
    let focusedField: FocusState<Field?>.Binding
    var onMicTap: () -> Void = {}

    private let characterLimit = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack(alignment: .top, spacing: 8) {

                ZStack(alignment: .topLeading) {

                    if text.isEmpty {
                        Text("new.item.textfield.placeholder")
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }

                    VStack(alignment: .leading, spacing: 4) {

                        if !text.isEmpty {
                            Text("new.item.textfield.placeholder")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 5)
                        }

                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .focused(focusedField, equals: .title)
                            .frame(minHeight: 60)
                            .onChange(of: text) { _, newValue in
                                if newValue.count > characterLimit {
                                    text = String(newValue.prefix(characterLimit))
                                }
                            }
                    }
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

            HStack {
                Spacer()
                Text("\(text.count)/\(characterLimit)",)
                    .font(.caption)
                    .foregroundStyle(text.count >= characterLimit ? .red : .secondary)
                
                Text("new.item.textfield.characters",)
                    .font(.caption)
                    .foregroundStyle(text.count >= characterLimit ? .red : .secondary)
            }
            //.padding(.horizontal, 4)
        }
    }
}

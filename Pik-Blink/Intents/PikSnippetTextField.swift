//////
//////  PikSnippetTextField.swift
//////  Pik-Blink
//////
//////  Created by Arnau on 25/09/2026.
//////
//////
//

import SwiftUI
import AppIntents

struct PikSnippetTextField: View {

    let draft: PikDraftEntity
    let text: String

    private let title = "Pik Blink"
    private let subtitle = "Capture your idea in a blink."
    private let characterLimit = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Título fuera del recuadro
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Campo
            Button(intent: SetTextIntent(draft: draft)) {
                VStack(alignment: .leading) {
                    if text.isEmpty {
                        Text("Tap to write…")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 60, alignment: .topLeading)
                    } else {
                        Text(text)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 60, alignment: .topLeading)
                    }
                }
                .padding(14)
                .background(.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                .background(Color(.secondarySystemBackground))
//                .overlay {
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .stroke(Color(.separator), lineWidth: 1)
//                }
//                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            HStack {
                Spacer()
                Text("\(text.count)/\(characterLimit) characters")
                    .font(.caption)
                    .foregroundStyle(
                        text.count >= characterLimit ? .red : .secondary
                    )
            }
            .padding(.horizontal, 4)
        }
    }
}

//import SwiftUI
//import AppIntents
//
//struct PikSnippetTextField: View {
//
//    let draft: PikDraftEntity
//    let text: String
//
//    private let placeholder = "Capture your idea in a blink."
//    private let characterLimit = 100
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//
//            HStack(alignment: .top, spacing: 8) {
//
//                Button(intent: SetTextIntent(draft: draft)) {
//
//                    ZStack(alignment: .topLeading) {
//
//                        if draft.text.isEmpty {
//                            Text(placeholder)
//                                .foregroundStyle(.secondary)
//                                .padding(.top, 8)
//                                .padding(.leading, 5)
//                        }
//
//                        VStack(alignment: .leading, spacing: 4) {
//
//                            if !draft.text.isEmpty {
//                                Text(placeholder)
//                                    .font(.caption)
//                                    .foregroundStyle(.secondary)
//                                    .padding(.leading, 5)
//                            }
//
//                            Text(draft.text.isEmpty ? " " : draft.text)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .frame(minHeight: 60, alignment: .topLeading)
//                                .foregroundStyle(.primary)
//                        }
//                    }
//                    .contentShape(Rectangle())
//                }
//                .buttonStyle(.plain)
//
////                Button(intent: RecordVoiceIntent(draft: draft)) {
////                    Image(systemName: "mic.fill")
////                        .font(.title2)
////                        .foregroundStyle(.blue)
////                }
////                .buttonStyle(.plain)
////                .padding(.top, 8)
//                
////                Image(systemName: "mic.fill")
////                    .font(.title2)
////                    .foregroundStyle(.blue.opacity(0.35))
////                    .padding(.top, 8)
////            }
////            .padding(14)
//            .frame(minHeight: 96)
//            .background(Color(.secondarySystemBackground))
//            .overlay {
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .stroke(Color(.separator), lineWidth: 1)
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//
//            HStack {
//                Spacer()
//
//                Text("\(draft.text.count)/\(characterLimit) characters")
//                    .font(.caption)
//                    .foregroundStyle(
//                        draft.text.count >= characterLimit
//                        ? .red
//                        : .secondary
//                    )
//            }
//            .padding(.horizontal, 4)
//        }
//    }
//}
//
////import SwiftUI
////import AppIntents
////
////struct PikSnippetTextField: View {
////
////    let draft: PikDraftEntity
////
////    private let placeholder = "Capture your idea in a blink."
////    private let characterLimit = 100
////
////    var body: some View {
////        VStack(alignment: .leading, spacing: 6) {
////
////            HStack(alignment: .top, spacing: 8) {
////
////                Button(intent: SetTextIntent(draft: draft)) {
////
////                    ZStack(alignment: .topLeading) {
////
////                        if draft.text.isEmpty {
////                            Text(placeholder)
////                                .foregroundStyle(.secondary)
////                                .padding(.top, 8)
////                                .padding(.leading, 5)
////                        }
////
////                        VStack(alignment: .leading, spacing: 4) {
////
////                            if !draft.text.isEmpty {
////                                Text(placeholder)
////                                    .font(.caption)
////                                    .foregroundStyle(.secondary)
////                                    .padding(.leading, 5)
////                            }
////
////                            Text(draft.text.isEmpty ? " " : draft.text)
////                                .frame(maxWidth: .infinity, alignment: .leading)
////                                .frame(minHeight: 60, alignment: .topLeading)
////                                .foregroundStyle(.primary)
////                        }
////                    }
////                }
////                .buttonStyle(.plain)
////
//////                Button(intent: RecordVoiceIntent(draft: draft)) {
//////                    Image(systemName: "mic.fill")
//////                        .font(.title2)
//////                        .foregroundStyle(.blue)
//////                }
//////                .buttonStyle(.plain)
//////                .padding(.top, 8)
////                Button(intent: SetTextIntent(draft: draft)) {
////                    Image(systemName: "mic.fill")
////                        .font(.title2)
////                        .foregroundStyle(.blue.opacity(0.4))
////                }
////                .buttonStyle(.plain)
////                .disabled(true)
////                .padding(.top, 8)
////            }
////            .padding(14)
////            .frame(minHeight: 96)
////            .background(Color(.secondarySystemBackground))
////            .overlay {
////                RoundedRectangle(cornerRadius: 20, style: .continuous)
////                    .stroke(Color(.separator), lineWidth: 1)
////            }
////            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
////
////            HStack {
////                Spacer()
////
////                Text("\\(draft.text.count)/\\(characterLimit) characters")
////                    .font(.caption)
////                    .foregroundStyle(
////                        draft.text.count >= characterLimit
////                        ? .red
////                        : .secondary
////                    )
////            }
////            .padding(.horizontal, 4)
////        }
////    }
//}

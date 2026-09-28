//
//  EditSnippetContent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents
import SwiftData

struct EditSnippetContent: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme

    let draft: PikDraftEntity
    let model: PikDraft
    let favorites: [FavoritePlaceSnippet]

    private var canSave: Bool {
        !model.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }
    
    private var backgroundColor: Color {
        colorScheme == .light
            ? Color.white.opacity(0.92)
            : Color(red: 0.12, green: 0.12, blue: 0.14).opacity(0.92)
    }

    private var primaryColor: Color {
        colorScheme == .light ? .black : .white
    }

    private var secondaryColor: Color {
        colorScheme == .light
            ? .black.opacity(0.6)
            : .white.opacity(0.72)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            PikSnippetTextField(
                draft: draft,
                text: model.text
            )

            switch model.reminderType {

            case .none:
                ReminderChoiceView(draft: draft)

            case .date:
                if model.isPickingCustomDate {
                    CustomDatePickerView(draft: draft)
                } else if model.remindAt == nil {
                    WhenQuickReminderView(draft: draft)
                } else {
                    ReminderSummaryView(
                        draft: draft,
                        date: model.remindAt!
                    )
                }

            case .location:
                if model.placeName == nil {
                    FavoritePlacesView(
                        draft: draft,
                        favorites: favorites
                    )
                } else {
                    LocationSummaryView(
                        draft: draft,
                        label: model.placeLabel ?? model.placeName!,
                        address: model.placeAddress ?? ""
                    )
                }
            }

            if canSave {
                Button(intent: SaveDraftIntent(draft: draft)) {
                    saveLabel
                }
                .buttonStyle(.plain)
            } else {
                saveLabel
                    .opacity(0.5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var saveLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)

            Text("Save Pik")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

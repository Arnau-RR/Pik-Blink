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

    let draft: PikDraftEntity
    let model: PikDraft
    let favorites: [FavoritePlaceSnippet]

    private var canSave: Bool {
        !model.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
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
        .environment(\.colorScheme, .dark)
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

//struct EditSnippetContent: View {
//    
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var context
//    
//    let draft: PikDraftEntity
//    let model: PikDraft
//    let favorites: [FavoritePlaceSnippet]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            
//            PikSnippetTextField(
//                draft: draft,
//                text: model.text
//            )
//            
////            if let date = model.remindAt {
////                ReminderSummaryView(draft: draft,date: date)
////            }
//            
////            if let location = model.locationName {
////                LocationSummaryView(
////                    label: model.placeLabel ?? model.placeName!,
////                    address: model.placeAddress ?? ""
////                )
////            }
//            
//            switch model.reminderType {
//                
//            case .none:
//                ReminderChoiceView(draft: draft)
//                
//            case .date:
//                
//                if model.isPickingCustomDate {
//                    
//                    CustomDatePickerView(draft: draft)
//                    
//                } else if model.remindAt == nil {
//                    
//                    WhenQuickReminderView(draft: draft)
//                    
//                } else {
//                    
//                    ReminderSummaryView(
//                        draft: draft,
//                        date: model.remindAt!
//                    )
//                }
//                
//            case .location:
//                if model.placeName == nil {
//                    FavoritePlacesView(
//                        draft: draft,
//                        favorites: favorites
//                    )
//                } else {
//                    LocationSummaryView(
//                        draft: draft,
//                        label: model.placeLabel ?? model.placeName!,
//                        address: model.placeAddress ?? ""
//                    )
//                }
//                
//            }
//            
//            Button(intent: SaveDraftIntent(draft: draft)) {
//                HStack(spacing: 8) {
//                    Image(systemName: "checkmark.circle.fill")
//                        .font(.title3)
//
//                    Text("Save Pik")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                }
//                .foregroundStyle(.white)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 10)
//                .background(Color.green)
//                .clipShape(RoundedRectangle(cornerRadius: 18))
//            }
//            .disabled(model.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//            .opacity(model.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
//            .buttonStyle(.plain)
//        }
//        .padding()
//        .environment(\.colorScheme, .dark)
//    }
//}

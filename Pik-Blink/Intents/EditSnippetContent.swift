//
//  EditSnippetContent.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct EditSnippetContent: View {

    let draft: PikDraftEntity
    let model: PikDraft

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            PikSnippetTextField(
                draft: draft,
                text: model.text
            )
            
//            if let date = model.remindAt {
//
//                Label {
//                    Text(date, style: .date)
//                } icon: {
//                    Image(systemName: "calendar")
//                }
//                .font(.subheadline)
//                .foregroundStyle(.blue)
//            }
            
//            if let date = model.remindAt {
//
//                HStack(spacing: 8) {
//                    Image(systemName: "calendar")
//
//                    Text(date, format: .dateTime.day().month().hour().minute())
//                }
//                .font(.subheadline)
//            }
            
            if let date = model.remindAt {
                ReminderSummaryView(    draft: draft,date: date)
            }
            
            if let location = model.locationName {
                LocationSummaryView(location: location)
            }
            
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
                
//                WhenQuickReminderView(draft: draft)
//                if model.remindAt == nil {
//                    WhenQuickReminderView(draft: draft)
//                } else {
//                    EmptyView()
//                }


            case .location:
                EmptyView()
                
            case nil:
                ReminderChoiceView(draft: draft)
            
            }
            
//            switch model.reminderType {
//            case .none:
//                ReminderChoiceView(draft: draft)
//
//            case .date:
//                Text("⏰ Here we'll reuse your WhenView")
//
//            case .location:
//                Text("📍 Here we'll reuse your LocationView")
//
//            case nil:
//                ReminderChoiceView(draft: draft)
//            }
//            if model.reminderType == .none {
//
//                ReminderChoiceView(draft: draft)
//
//            } else if model.reminderType == .time {
//
//                Text("⏰ Here we'll reuse your WhenView")
//
//            } else {
//
//                Text("📍 Here we'll reuse your LocationView")
//            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}

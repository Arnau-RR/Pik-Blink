////
////  WhenQuickReminderView.swift
////  Pik-Blink
////
////  Created by Arnau on 25/09/2026.
////
//

import SwiftUI
import AppIntents

struct WhenQuickReminderView: View {

    let draft: PikDraftEntity

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("When should I remind you?")
                    .font(.headline)

                Spacer()

                Button(intent: SetReminderChoiceIntent(
                    draft: draft,
                    choice: .none
                )) {
                    Text("Change")
                }
                .buttonStyle(.borderless)
            }

            LazyVGrid(columns: columns, spacing: 12) {

                ChoiceButton(
                    title: "+30 min",
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .thirtyMinutes
                    )
                )

                ChoiceButton(
                    title: "+1 h",
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .oneHour
                    )
                )

                ChoiceButton(
                    title: "+2 h",
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .twoHours
                    )
                )

                ChoiceButton(
                    title: "Custom",
                    icon: "calendar",
                    intent: PickCustomDateIntent(draft: draft)
                )
            }
        }
    }
}
//import SwiftUI
//import AppIntents
//
//struct WhenQuickReminderView: View {
//
//    let draft: PikDraftEntity
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            HStack {
//                Text("When should I remind you?")
//                    .font(.headline)
//
//                Spacer()
//
//                Button(intent: SetReminderChoiceIntent(
//                    draft: draft,
//                    choice: .none
//                )) {
//                    Text("Change")
//                }
//                .buttonStyle(.borderless)
//            }
//
//            VStack(spacing: 8) {
//
//                QuickReminderRow(
//                    title: "+30 min",
//                    subtitle: "In half an hour",
//                    icon: "clock",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .thirtyMinutes
//                    )
//                )
//
//                QuickReminderRow(
//                    title: "+1 hour",
//                    subtitle: "In one hour",
//                    icon: "clock.badge.plus",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .oneHour
//                    )
//                )
//
//                QuickReminderRow(
//                    title: "+2 hours",
//                    subtitle: "In two hours",
//                    icon: "timer",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .twoHours
//                    )
//                )
//
//                QuickReminderRow(
//                    title: "Custom",
//                    subtitle: "Choose date & time",
//                    icon: "calendar",
//                    intent: PickCustomDateIntent(draft: draft)
//                )
//            }
//        }
//    }
//}

//import SwiftUI
//import AppIntents
//
//struct WhenQuickReminderView: View {
//
//    let draft: PikDraftEntity
//
//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 12) {
//            
//            HStack {
//                Text("When should I remind you?")
//                    .font(.headline)
//
//                Spacer()
//
//                Button(intent: SetReminderChoiceIntent(
//                    draft: draft,
//                    choice: .none
//                )) {
//                    Text("Change")
//                }
//                .buttonStyle(.borderless)
//            }
//
//            VStack(spacing: 8) {
//
//                QuickReminderRow(
//                    title: "Today",
//                    subtitle: "This afternoon",
//                    icon: "sun.max",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .today
//                    )
//                )
//
//                QuickReminderRow(
//                    title: "Tonight",
//                    subtitle: "20:00",
//                    icon: "moon",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .tonight
//                    )
//                )
//
//                QuickReminderRow(
//                    title: "Tomorrow",
//                    subtitle: "09:00",
//                    icon: "sunrise",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .tomorrow
//                    )
//                )
//                
//                QuickReminderRow(
//                    title: "Pick a date",
//                    subtitle: "Choose manually",
//                    icon: "calendar",
//                    intent: PickCustomDateIntent(draft: draft)
//                )
//            }
//        }
//    }
//}

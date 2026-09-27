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

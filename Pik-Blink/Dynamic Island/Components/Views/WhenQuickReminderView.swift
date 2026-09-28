//
//  WhenQuickReminderView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
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
                Text("reminder.quick.selection.title")
                    .font(.caption2)

                Spacer()

                Button(intent: SetReminderChoiceIntent(
                    draft: draft,
                    choice: .none
                )) {
                    Text("reminder.quick.selection.change.button")
                }
                .buttonStyle(.borderless)
            }

            LazyVGrid(columns: columns, spacing: 12) {

                ChoiceButton(
                    title: Text("reminder.quick.option.thirty.minutes"),
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .thirtyMinutes
                    )
                )

                ChoiceButton(
                    title: Text("reminder.quick.option.one.hour"),
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .oneHour
                    )
                )

                ChoiceButton(
                    title: Text("reminder.quick.option.two.hours"),
                    icon: "timer",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .twoHours
                    )
                )

                ChoiceButton(
                    title: Text("reminder.quick.option.custom"),
                    icon: "calendar",
                    intent: PickCustomDateIntent(draft: draft)
                )
            }
        }
    }
}

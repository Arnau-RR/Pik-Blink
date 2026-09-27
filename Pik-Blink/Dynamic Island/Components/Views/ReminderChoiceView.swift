//
//  ReminderChoiceView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct ReminderChoiceView: View {

    let draft: PikDraftEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(String(localized: "reminder.choice.title"))
                .font(.caption)

            HStack(spacing: 10) {

                ChoiceButton(
                    title: String(localized: "reminder.choice.option.when"),
                    icon: "calendar",
                    intent: SetReminderChoiceIntent(
                        draft: draft,
                        choice: .time
                    )
                )

                ChoiceButton(
                    title: String(localized: "reminder.choice.option.where"),
                    icon: "location",
                    intent: PickLocationIntent(draft: draft)
                )
            }
        }
    }
}

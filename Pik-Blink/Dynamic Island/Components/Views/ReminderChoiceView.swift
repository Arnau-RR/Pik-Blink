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

            Text("How should I remind you?")
                .font(.caption)

            HStack(spacing: 10) {

                ChoiceButton(
                    title: "When",
                    icon: "calendar",
                    intent: SetReminderChoiceIntent(
                        draft: draft,
                        choice: .time
                    )
                )

                ChoiceButton(
                    title: "Where",
                    icon: "location",
                    intent: PickLocationIntent(draft: draft)
                )
            }
        }
    }
}

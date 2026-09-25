//
//  WhenQuickReminderView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct WhenQuickReminderView: View {

    let draft: PikDraftEntity

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("When should I remind you?")
                .font(.headline)

            VStack(spacing: 8) {

                QuickReminderRow(
                    title: "Today",
                    subtitle: "This afternoon",
                    icon: "sun.max",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .today
                    )
                )

                QuickReminderRow(
                    title: "Tonight",
                    subtitle: "20:00",
                    icon: "moon",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .tonight
                    )
                )

                QuickReminderRow(
                    title: "Tomorrow",
                    subtitle: "09:00",
                    icon: "sunrise",
                    intent: SetQuickReminderIntent(
                        draft: draft,
                        option: .tomorrow
                    )
                )

//                QuickReminderRow(
//                    title: "Pick a date",
//                    subtitle: "Choose manually",
//                    icon: "calendar",
//                    intent: SetQuickReminderIntent(
//                        draft: draft,
//                        option: .custom
//                    )
//                )
                
                QuickReminderRow(
                    title: "Pick a date",
                    subtitle: "Choose manually",
                    icon: "calendar",
                    intent: PickCustomDateIntent(draft: draft)
                )
            }
        }
    }
}

////
////  ReminderChoiceView.swift
////  Pik-Blink
////
////  Created by Arnau on 25/09/2026.
////
//

import SwiftUI

struct ReminderChoiceView: View {

    let draft: PikDraftEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("How should I remind you?")
                .font(.headline)

            HStack(spacing: 10) {

                ChoiceButton(
                    title: "None",
                    icon: "minus.circle",
                    intent: SetReminderChoiceIntent(
                        draft: draft,
                        choice: .none
                    )
                )

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
//                ChoiceButton(
//                    title: "Where",
//                    icon: "location",
//                    intent: PickLocationIntent(draft: draft)
//                )
//                ChoiceButton(
//                    title: "Where",
//                    icon: "location",
//                    intent: SetReminderChoiceIntent(
//                        draft: draft,
//                        choice: .location
//                    )
//                )
            }
        }
    }
}

//import SwiftUI
//import AppIntents
//
//struct ReminderChoiceView: View {
//
//    let draft: PikDraftEntity
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            Text("How should I remind you?")
//                .font(.headline)
//
//            HStack(spacing: 10) {
//
//                ChoiceButton(
//                    title: "None",
//                    icon: "minus.circle",
//                    intent: SetReminderChoiceIntent(
//                        draft: draft,
//                        choice: .none
//                    )
//                )
//
//                ChoiceButton(
//                    title: "When",
//                    icon: "calendar",
//                    intent: SetReminderChoiceIntent(
//                        draft: draft,
//                        choice: .time
//                    )
//                )
//
//                ChoiceButton(
//                    title: "Where",
//                    icon: "location",
//                    intent: SetReminderChoiceIntent(
//                        draft: draft,
//                        choice: .location
//                    )
//                )
//            }
//        }
//    }
//}

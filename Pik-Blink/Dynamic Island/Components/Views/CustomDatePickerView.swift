//
//  CustomDatePickerView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import AppIntents

struct CustomDatePickerView: View {

    let draft: PikDraftEntity

    @State private var date = Date()

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("Pick a date")
                .font(.headline)

            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()

            Button(intent: SaveCustomDateIntent(
                draft: draft,
                date: date
            )) {

                Text("Save date")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

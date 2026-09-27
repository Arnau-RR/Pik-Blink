//
//  AppearanceSettingsView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct AppearanceSettingsView: View {

    @AppStorage("appAppearance")
    private var appearance = AppAppearance.system.rawValue

    var body: some View {
        SettingsDetailView(title: "Appearance") {

            Section {
                ForEach(AppAppearance.allCases) { option in
                    Button {
                        appearance = option.rawValue
                    } label: {
                        HStack {
                            Text(option.title)

                            Spacer()

                            if appearance == option.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } footer: {
                Text("Choose how Pik Blink appears. System follows your device settings.")
            }
        }
    }
}

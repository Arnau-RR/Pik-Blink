//
//  LanguageSettingsView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct LanguageSettingsView: View {

    @AppStorage("appLanguage")
    private var language = AppLanguage.system.rawValue

    var body: some View {
        SettingsDetailView(title: "Language") {

            Section {
                ForEach(AppLanguage.allCases) { option in
                    Button {
                        language = option.rawValue
                        Bundle.setLanguage(option == .system ? nil : option.rawValue)
                    } label: {
                        HStack {
                            Text(option.title)
                            Spacer()

                            if language == option.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } footer: {
                Text("System follows your device language.")
            }
        }
    }
}

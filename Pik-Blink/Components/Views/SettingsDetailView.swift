//
//  SettingsDetailView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct SettingsDetailView<Content: View>: View {
    let title: String
    let content: Content

    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        List {
            content
        }
        .listStyle(.insetGrouped)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

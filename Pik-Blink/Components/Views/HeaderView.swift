//
//  HeaderView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct HeaderView<Actions: View>: View {

    let title: String
    let subtitle: String?
    @ViewBuilder let actions: Actions

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actions = actions()
    }

    var body: some View {
        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.system(size: 34, weight: .bold))

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                actions
            }
        }
        .padding(.top, 12)
    }
}

#Preview("Light") {
    HeaderView(
        title: "Pik Blink",
        subtitle: "Capture ideas in a blink."
    ) {
        GlassIconButton(icon: "magnifyingglass") {}
        GlassIconButton(icon: "plus") {}
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HeaderView(
        title: "Pik Blink",
        subtitle: "Capture ideas in a blink."
    ) {
        GlassIconButton(icon: "magnifyingglass") {}
        GlassIconButton(icon: "plus") {}
    }
    .preferredColorScheme(.dark)
}

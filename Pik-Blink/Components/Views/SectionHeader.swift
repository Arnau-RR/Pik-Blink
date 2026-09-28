//
//  SectionHeader.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: LocalizedStringKey?
    let subtitle: LocalizedStringKey?
    let titleFont: Font
    let subtitleFont: Font

    init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        titleFont: Font = .title3,
        subtitleFont: Font = .subheadline
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(titleFont)
                    .fontWeight(.semibold)
            }

            if let subtitle {
                Text(subtitle)
                    .font(subtitleFont)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

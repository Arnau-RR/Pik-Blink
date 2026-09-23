//
//  SectionHeader.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct SectionHeader: View {

    let title: String?
    let subtitle: String?

    init(
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            if let title, !title.isEmpty {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

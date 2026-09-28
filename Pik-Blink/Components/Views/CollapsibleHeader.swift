//
//  CollapsibleHeader.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import SwiftUI

struct CollapsibleHeader: View {
    let title: String
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.bold))

                Text(title)
                    .font(.headline)

                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

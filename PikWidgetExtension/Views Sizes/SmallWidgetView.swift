//
//  SmallWidgetView.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import SwiftUI

struct SmallWidgetView: View {

    @Environment(\.colorScheme) private var colorScheme

    private var isDark: Bool { colorScheme == .dark }

    var body: some View {

        VStack(spacing: 12) {

            Spacer()

            ZStack {
                Circle()
                    .fill(isDark ? .white : .black)

                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(isDark ? .black : .white)
            }
            .frame(width: 68, height: 68)

            VStack(spacing: 2) {
                Text(String(localized: "widget.small.new.pik.title"))
                    .font(.headline)

                Text(String(localized: "widget.small.tap.to.capture.subtitle"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
    }

}

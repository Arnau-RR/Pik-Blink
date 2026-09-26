////
////  PikWidgetEntryView.swift
////  Pik-Blink
////
////  Created by Arnau on 26/09/2026.
////
//
import SwiftUI
import WidgetKit

struct PikWidgetEntryView: View {
    let entry: PikEntry

    @Environment(\.colorScheme) private var colorScheme

    private var isDark: Bool { colorScheme == .dark }

    var body: some View {
        ZStack {
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
                    Text("New Pik")
                        .font(.headline)
                        .foregroundStyle(isDark ? .white : .black)

                    Text("Tap to capture")
                        .font(.caption2)
                        .foregroundStyle(isDark ? .white.opacity(0.65) : .black.opacity(0.6))
                }

                Spacer()
            }
            .padding()
        }
        .containerBackground(Color(.systemBackground), for: .widget)
        .widgetURL(URL(string: "pikblink://new"))
    }
}

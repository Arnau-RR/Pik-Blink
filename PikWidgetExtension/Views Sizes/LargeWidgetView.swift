//
//  LargeWidgetView.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import SwiftUI
import AppIntents

struct LargeWidgetView: View {

    let entry: PikEntry

    private var visiblePiks: [PikItem] {
        Array(entry.piks.prefix(6))
    }

    private var remaining: Int {
        max(0, entry.piks.count - 6)
    }

    var body: some View {
        HStack(spacing: 14) {

            // LEFT
            VStack(alignment: .leading, spacing: 4) {

                Text("widget.large.today.title")
                    .font(.headline)

                Text("\(entry.piks.count)")
                    .font(.system(size: 36, weight: .bold))

                Text("widget.large.pending.label")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .frame(width: 72, alignment: .topLeading)
            .padding()

            Divider()

            // RIGHT
            VStack(alignment: .leading, spacing: 10) {

                if visiblePiks.isEmpty {

                    Spacer()

                    VStack(alignment: .center, spacing: 4) {
                        Text("widget.large.empty.title")
                            .font(.headline)

                        Text("widget.large.empty.subtitle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 190)

                    Spacer()

                } else {

                    ForEach(visiblePiks) { pik in
                        HStack(spacing: 10) {

                            Button(intent: CompletePikIntent(id: pik.id)) {
                                Image(systemName: "circle")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)

                            VStack(alignment: .leading, spacing: 1) {

                                Text(pik.text)
                                    .font(.subheadline)
                                    .lineLimit(1)

                                subtitle(for: pik)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .frame(height: 32)
                    }

                    Spacer(minLength: 0)

                    if remaining > 0 {
                        Divider()

                        Text(
                            String(
                                localized: "widget.large.remaining.count",
                                defaultValue: "+\(remaining) more"
                            )
                        )
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private func subtitle(for pik: PikItem) -> Text {
        if pik.reminderType == .location {
            if let placeName = pik.placeName {
                return Text(verbatim: placeName)
            } else {
                return Text("widget.large.location.label")
            }
        }

        guard let date = pik.remindAt else {
            return Text("widget.large.no.reminder")
        }

        return Text(date.formatted(.dateTime.hour().minute()))
    }
//    private func subtitle(for pik: PikItem) -> String {
//        if pik.reminderType == .location {
//            return pik.placeName ?? "widget.large.location.label"
//        }
//
//        guard let date = pik.remindAt else {
//            return "widget.large.no.reminder"
//        }
//
//        return date.formatted(.dateTime.hour().minute())
//    }
}

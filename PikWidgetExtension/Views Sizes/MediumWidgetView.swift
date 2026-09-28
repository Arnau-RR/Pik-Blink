//
//  MediumWidgetView.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

import SwiftUI
import AppIntents

struct MediumWidgetView: View {

    @Environment(\.colorScheme) private var colorScheme

    let entry: PikEntry

    private var visiblePiks: [PikItem] { Array(entry.piks.prefix(3)) }
    private var remaining: Int { max(0, entry.piks.count - 3) }

    var body: some View {
        HStack(spacing: 14) {

            // MARK: Left summary

            VStack(alignment: .leading, spacing: 2) {

                Text("widget.medium.today.title")
                    .font(.headline)

                Text("\(entry.piks.count)")
                    .font(.system(size: 34, weight: .bold))

                Text("widget.medium.pending.label")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .frame(width: 72, alignment: .topLeading)
            .padding()

            Divider()

            // MARK: Right list

            VStack(alignment: .leading, spacing: 7) {

                if visiblePiks.isEmpty {

                    Spacer()

                    VStack(alignment: .center, spacing: 4) {
                        Text("widget.medium.empty.title")
                            .font(.subheadline)

                        Text("widget.medium.empty.subtitle")
                            .font(.caption2)
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
                                    .font(.footnote)
                                    .lineLimit(1)

                                subtitle(for: pik)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .frame(height: 30)
                    }

                    Spacer(minLength: 0)

                    if remaining > 0 {
                        Divider()

                        Text(
                            String(
                                localized: "widget.medium.remaining.count",
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
                return Text("widget.medium.location.label")
            }
        }

        guard let date = pik.remindAt else {
            return Text("widget.medium.no.reminder")
        }

        return Text(date.formatted(.dateTime.hour().minute()))
    }
}

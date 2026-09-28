//
//  PikLiveActivity.swift
//  Pik-Blink
//
//  Created by Arnau on 28/09/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PikLiveActivity: Widget {

    var body: some WidgetConfiguration {

        ActivityConfiguration(for: PikLiveActivityAttributes.self) { context in

            VStack(alignment: .leading, spacing: 12) {

                // Header
                HStack(spacing: 6) {
                    Image(systemName: "checklist")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Text("PIK BLINK")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                // Title
                Text(context.state.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                // Status row
                statusRow(context)
            }
            .padding()

        } dynamicIsland: { context in

            DynamicIsland {

                DynamicIslandExpandedRegion(.center) {

                    VStack(spacing: 10) {

                        Text(context.state.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)

                        expandedStatus(context)
                    }
                    .padding(.vertical, 4)
                }

            } compactLeading: {

                Image(systemName: compactIcon(context))
                    .font(.caption)

            } compactTrailing: {

                compactTrailing(context)

            } minimal: {

                Image(systemName: compactIcon(context))
            }
        }
    }
}

// MARK: - Lock Screen

extension PikLiveActivity {

    @ViewBuilder
    private func statusRow(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        switch context.state.reminderType {

        case .date:

            if let date = context.state.reminderDate {

                HStack {

                    Label {
                        Text(timerInterval: Date()...date, countsDown: true)
                            .monospacedDigit()
                    } icon: {
                        Image(systemName: "clock")
                    }

                    Spacer()

                    Text(date, style: .time)
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }

        case .location:

            HStack {

                Label {
                    Text(context.state.placeName ?? String(localized: "live.activity.location.unknown"))
                } icon: {
                    Image(systemName: "location.fill")
                }

                Spacer()
            }
            .font(.subheadline)

        case .none:

            HStack {

                Label {
                    Text("live.activity.no.reminder")
                } icon: {
                    Image(systemName: "sparkles")
                }

                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Dynamic Island

extension PikLiveActivity {

    @ViewBuilder
    private func expandedStatus(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        switch context.state.reminderType {

        case .date:

            if let date = context.state.reminderDate {

                VStack(spacing: 2) {

                    Text(timerInterval: Date()...date, countsDown: true)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .monospacedDigit()

                    Text(date, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

        case .location:

            Label(
                context.state.placeName ?? String(localized: "live.activity.location.unknown"),
                systemImage: "location.fill"
            )
            .font(.headline)

        case .none:

            VStack(spacing: 4) {

                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text("live.activity.no.reminder")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func compactIcon(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> String {

        switch context.state.reminderType {
        case .date: "clock"
        case .location: "location.fill"
        case .none: "sparkles"
        }
    }

    @ViewBuilder
    private func compactTrailing(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        switch context.state.reminderType {

        case .date:

            if let date = context.state.reminderDate {

                Text(timerInterval: Date()...date, countsDown: true)
                    .monospacedDigit()
                    .font(.caption2)
            }

        case .location:

            Image(systemName: "location.fill")
                .font(.caption)

        case .none:

            Image(systemName: "sparkles")
                .font(.caption)
        }
    }
}

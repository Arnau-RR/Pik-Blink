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

            VStack(alignment: .leading, spacing: 14) {

                // MARK: Header

                HStack(spacing: 8) {

                    Image(systemName: "checklist")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)

                    Text("PIK BLINK")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                }

                // MARK: Title

                Text(context.state.title)
                    .font(.title3.weight(.semibold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.white)


                Divider()

                // MARK: Status

                lockScreenStatus(context)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.white)
            //.padding()

        } dynamicIsland: { context in

            DynamicIsland {

                // MARK: Expanded

                DynamicIslandExpandedRegion(.center) {

                    HStack(alignment: .center, spacing: 14) {

                        ZStack {

                            Circle()
                                .fill(.white.opacity(0.12))
                                .frame(width: 46, height: 46)

                            Image(systemName: compactIcon(context))
                                .font(.title3)
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {

                            Text("PIK BLINK")
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(context.state.title)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)

                            expandedStatus(context)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                }

            } compactLeading: {

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 20, height: 20)

                    Image(systemName: compactIcon(context)) // tu asset monocromo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 11, height: 11)
                }
                
//                Image(systemName: compactIcon(context))
//                    .font(.caption.weight(.semibold))

            } compactTrailing: {

                if context.state.reminderType == .date,
                      let date = context.state.reminderDate {

                       Text(timerInterval: Date()...date, pauseTime: nil, countsDown: true, showsHours: false)
                           .font(.system(size: 12, weight: .bold, design: .rounded))
                           .monospacedDigit()
                           .multilineTextAlignment(.trailing)
                           .frame(width: 40, alignment: .trailing)   // ancho fijo, no minWidth

                   } else if context.state.reminderType == .location {

                       Image(systemName: "location.fill")
                           .font(.system(size: 11, weight: .semibold))

                   } //else {

//                       Image(systemName: "sparkles")
//                           .font(.system(size: 11, weight: .semibold))
                   //}

            } minimal: {

                Image(systemName: compactIcon(context))
            }
        }
    }
}

// MARK: - Lock Screen

private extension PikLiveActivity {

    @ViewBuilder
    func lockScreenStatus(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        switch context.state.reminderType {

        case .date:

            if let date = context.state.reminderDate {

                HStack {

                    Label {
                        Text(timerInterval: Date()...date, countsDown: true)
                            .monospacedDigit()
                            .foregroundStyle(.white)

                    } icon: {
                        Image(systemName: "clock")
                            .foregroundStyle(.white)

                    }

                    Spacer()

                    Text(date, style: .time)
                        .foregroundStyle(.white)

                }
                .font(.subheadline)
            }

        case .location:

            HStack {

                Label {
                    Text(context.state.placeName ?? String(localized: "live.activity.location.unknown"))
                        .foregroundStyle(.white)

                } icon: {
                    Image(systemName: "location.fill")
                        .foregroundStyle(.white)

                }

                Spacer()
            }
            .font(.subheadline)

        case .none:

            HStack {

                Label {
                    Text("live.activity.no.reminder")
                        .foregroundStyle(.white)

                } icon: {
                    Image(systemName: "sparkles")
                }

                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Dynamic Island

private extension PikLiveActivity {

    @ViewBuilder
    func expandedStatus(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        switch context.state.reminderType {

        case .date:

            if let date = context.state.reminderDate {

                VStack(alignment: .leading, spacing: 0) {

                    Text(timerInterval: Date()...date, countsDown: true)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text(date, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

        case .location:

            HStack(spacing: 6) {

                Image(systemName: "location.fill")
                    .font(.caption)

                Text(context.state.placeName ?? String(localized: "live.activity.location.unknown"))
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.secondary)

        case .none:

            HStack(spacing: 6) {

                Image(systemName: "sparkles")
                    .font(.caption)

                Text("live.activity.no.reminder")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }

    func compactIcon(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> String {

        switch context.state.reminderType {
        case .date:
            return "clock.fill"
        case .location:
            return "location.fill"
        case .none:
            return "sparkles"
        }
    }

    @ViewBuilder
    func compactTrailing(_ context: ActivityViewContext<PikLiveActivityAttributes>) -> some View {

        if let date = context.state.reminderDate {
                Text(timerInterval: Date()...date, pauseTime: nil, countsDown: true, showsHours: false)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .frame(width: 40, alignment: .trailing)
            }
    }
}

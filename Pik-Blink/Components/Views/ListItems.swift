//
//  ListItems.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct ListItems: View {

    let listElements: [PikItem]
    let showArchivedActions: Bool
    let forceExpanded: Bool

    let onPress: (PikItem) -> Void
    let onToggle: (PikItem) -> Void
    let onArchive: (PikItem) -> Void
    let onUnarchive: (PikItem) -> Void
    let onDelete: (PikItem) -> Void

    @State private var locationsExpanded = false
    @State private var futureExpanded = false
    @State private var expandedSections: Set<Date> = [Calendar.current.startOfDay(for: .now)]

    // MARK: Data

    private var locationItems: [PikItem] {
        listElements
            .filter { $0.reminderType == .location }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private var futureItems: [PikItem] {
        let calendar = Calendar.current

        return listElements
            .filter {
                $0.reminderType == .date &&
                ($0.remindAt ?? .distantPast) > Date() &&
                !calendar.isDateInToday($0.remindAt!)
            }
            .sorted { ($0.remindAt ?? .distantFuture) < ($1.remindAt ?? .distantFuture) }
    }

    private var daySections: [(date: Date, items: [PikItem])] {
        let calendar = Calendar.current

        let remaining = listElements.filter { item in
            item.reminderType != .location &&
            !futureItems.contains(where: { $0.id == item.id })
        }

        let grouped = Dictionary(grouping: remaining) { item in
            let referenceDate: Date

            if item.reminderType == .date, let remindAt = item.remindAt {
                referenceDate = remindAt
            } else {
                referenceDate = item.createdAt
            }

            return calendar.startOfDay(for: referenceDate)
        }

        return grouped
            .map { date, items in
                (
                    date,
                    items.sorted {
                        let lhs = ($0.reminderType == .date ? $0.remindAt : $0.createdAt) ?? $0.createdAt
                        let rhs = ($1.reminderType == .date ? $1.remindAt : $1.createdAt) ?? $1.createdAt
                        return lhs > rhs
                    }
                )
            }
            .sorted { $0.date > $1.date }
    }

    private func isExpanded(_ date: Date) -> Bool {
        forceExpanded || expandedSections.contains(date)
    }

    var body: some View {
        Group {

            // Locations
            if !locationItems.isEmpty {
                Section {
                    if locationsExpanded || forceExpanded {
                        ForEach(locationItems) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        title: Text("main.list.section.locations"),
                        systemImage: "location.fill",
                        count: locationItems.count,
                        isExpanded: locationsExpanded || forceExpanded
                    ) {
                        locationsExpanded.toggle()
                    }
                }
            }

            // Future
            if !futureItems.isEmpty {
                Section {
                    if futureExpanded || forceExpanded {
                        ForEach(futureItems) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        title: Text("main.list.section.future"),
                        systemImage: "clock.badge",
                        count: futureItems.count,
                        isExpanded: futureExpanded || forceExpanded
                    ) {
                        futureExpanded.toggle()
                    }
                }
            }

            // Hoy / Ayer / ...
            ForEach(daySections, id: \.date) { section in
                Section {
                    if isExpanded(section.date) {
                        ForEach(section.items) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        title: section.date.sectionTitle,
                        systemImage: section.date.headerIcon,
                        count: section.items.count,
                        isExpanded: isExpanded(section.date)
                    ) {
                        toggle(section.date)
                    }
                }
            }
        }
    }

    // MARK: Components

    @ViewBuilder
    private func row(for item: PikItem) -> some View {
        Button {
            onPress(item)
        } label: {
            PikItemRow(item: item) {
                onToggle(item)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {

            if showArchivedActions {
                Button {
                    onUnarchive(item)
                } label: {
                    Label("main.list.action.unarchive", systemImage: "arrow.uturn.backward.circle")
                }
                .tint(.green)

            } else {
                Button {
                    onArchive(item)
                } label: {
                    Label("main.list.action.archive", systemImage: "archivebox")
                }
                .tint(.indigo)
            }

            Button(role: .destructive) {
                onDelete(item)
            } label: {
                Label("main.list.action.delete", systemImage: "trash")
            }
        }
    }

    private func toggle(_ date: Date) {
        if expandedSections.contains(date) {
            expandedSections.remove(date)
        } else {
            expandedSections.insert(date)
        }
    }
}

extension Date {
    var headerIcon: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return "sun.max.fill"
        }

        if calendar.isDateInYesterday(self) {
            return "moon.stars.fill"
        }

        return "calendar"
    }

    var sectionTitle: Text {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return Text("main.list.section.today")
        }

        if calendar.isDateInYesterday(self) {
            return Text("main.list.section.yesterday")
        }

        let start = calendar.startOfDay(for: self)
        let today = calendar.startOfDay(for: .now)
        let days = calendar.dateComponents([.day], from: start, to: today).day ?? 0

        if days <= 6 {
            return Text(formatted(.dateTime.weekday(.wide)).capitalized)
        }

        return Text(
            formatted(.dateTime.weekday(.wide).day().month(.wide)).capitalized
        )
    }
}

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
    
    let onPress: (PikItem) -> Void
    let onToggle: (PikItem) -> Void
    let onArchive: (PikItem) -> Void
    let onUnarchive: (PikItem) -> Void
    let onDelete: (PikItem) -> Void
    
    @State private var locationsExpanded = false
    @State private var futureExpanded = false
    @State private var expandedSections: Set<Date> = [Calendar.current.startOfDay(for: .now)]
    
    // MARK: Future
    
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
        
        let grouped = Dictionary(grouping: remaining) {
            calendar.startOfDay(for: $0.createdAt)
        }
        
        return grouped
            .map { ($0.key, $0.value.sorted { $0.createdAt > $1.createdAt }) }
            .sorted { $0.0 > $1.0 }
    }
    
    var body: some View {
        Group {
            
            // Locations
            if !locationItems.isEmpty {
                Section {
                    if locationsExpanded {
                        ForEach(locationItems) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        title: "Locations",
                        systemImage: "location.fill",
                        count: locationItems.count,
                        isExpanded: locationsExpanded
                    ) {
                        locationsExpanded.toggle()
                    }
                }
            }
            
            // Future
            if !futureItems.isEmpty {
                Section {
                    if futureExpanded {
                        ForEach(futureItems) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        
                        title: "Future",
                        systemImage: "clock.badge",
                        count: futureItems.count,
                        isExpanded: futureExpanded
                    ) {
                        futureExpanded.toggle()
                    }
                }
            }
            
            
            // Hoy / Ayer / ...
            ForEach(daySections, id: \.date) { section in
                Section {
                    if expandedSections.contains(section.date) {
                        ForEach(section.items) { item in row(for: item) }
                    }
                } header: {
                    PikSectionHeader(
                        title: section.date.sectionTitle,
                        systemImage: section.date.headerIcon,
                        count: section.items.count,
                        isExpanded: expandedSections.contains(section.date)
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
                    Label("Unarchive", systemImage: "arrow.uturn.backward.circle")
                }
                .tint(.green)
                
            } else {
                Button {
                    onArchive(item)
                } label: {
                    Label("Archive", systemImage: "archivebox")
                }
                .tint(.indigo)
            }
            
            Button(role: .destructive) {
                onDelete(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    @ViewBuilder
    private func header(
        title: String,
        expanded: Bool,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: expanded ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.semibold))
                
                Text(title)
                    .font(.headline)
                
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .textCase(nil)
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
    
    
    var sectionTitle: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return String(localized: "section.today")
        }
        
        if calendar.isDateInYesterday(self) {
            return String(localized: "section.yesterday")
        }
        
        let start = calendar.startOfDay(for: self)
        let today = calendar.startOfDay(for: .now)
        let days = calendar.dateComponents([.day], from: start, to: today).day ?? 0
        
        if days <= 6 {
            return formatted(.dateTime.weekday(.wide)).capitalized
        }
        
        return formatted(
            .dateTime.weekday(.wide).day().month(.wide)
        ).capitalized
    }
}

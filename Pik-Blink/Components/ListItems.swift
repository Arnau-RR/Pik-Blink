//
//  ListItems.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct ListItems: View {
    
    let listElements: [PikItem]
    
    let onToggle: (PikItem) -> Void
    let onArchive: (PikItem) -> Void
    let onDelete: (PikItem) -> Void
    
    private var sections: [(date: Date, items: [PikItem])] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: listElements) {
            calendar.startOfDay(for: $0.createdAt)
        }
        
        return grouped
            .map { (date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List {
            ForEach(sections, id: \.date) { section in
                Section(section.date.sectionTitle) {
                    ForEach(section.items) { item in
                        PikItemRow(item: item) {
                            onToggle(item)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                onArchive(item)
                            } label: {
                                Label("list.swipe.archive", systemImage: "archivebox")
                            }
                            .tint(.indigo)

                            Button(role: .destructive) {
                                onDelete(item)
                            } label: {
                                Label("list.swap.delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListItems(listElements: PikItem.mockList) { item in
        print("Toggle \(item)")
    } onArchive: { item in
        print("Archive \(item)")
    } onDelete: { item in
        print("Delete \(item)")
    }
}

extension Date {
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

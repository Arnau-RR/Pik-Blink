//
//  FavoritePlacesSettingsView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import SwiftData

struct FavoritePlacesSettingsView: View {

    @Environment(\.modelContext) private var context

    @Query(sort: \FavoritePlace.name)
    private var places: [FavoritePlace]

    @State private var showAdd = false

    var body: some View {
        SettingsDetailView(title: "settings.favoritePlaces.title") {

            Section {
                if places.isEmpty {
                    Text("settings.favoritePlaces.empty.message")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(places) { place in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.label)
                                .font(.headline)

                            Text(place.address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { context.delete(places[$0]) }
                        try? context.save()
                    }
                }
            }

            Section {
                Button {
                    showAdd = true
                } label: {
                    Label(
                        "settings.favoritePlaces.add.button",
                        systemImage: "plus.circle.fill"
                    )
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AddFavoritePlaceView()
                .presentationDetents([.height(520)])
                .presentationDragIndicator(.visible)
        }
    }
}

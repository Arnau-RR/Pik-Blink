//
//  FavoritePlacesView.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import SwiftUI
import AppIntents

struct FavoritePlacesView: View {

    let draft: PikDraftEntity
    let favorites: [FavoritePlaceSnippet]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text(String(localized: "favorite.places.snippet.title"))
                    .font(.caption2)

                Spacer()
                Button(intent: SetReminderChoiceIntent(
                    draft: draft,
                    choice: .none
                )) {
                    Text(String(localized: "favorite.places.snippet.change.button"))
                        .font(.caption2)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 5)

            if favorites.isEmpty {

                Text(String(localized: "favorite.places.snippet.empty.message"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

            } else {

                HStack(spacing: 12) {
                    ForEach(favorites) { place in
                        ChoiceButton(
                            title: place.label,
                            icon: "location.fill",
                            intent: SetFavoritePlaceIntent(
                                draft: draft,
                                label: place.label,
                                name: place.name,
                                address: place.address,
                                latitude: place.latitude,
                                longitude: place.longitude
                            )
                        )
                        .frame(width: 92)
                    }
                }
            }
        }
    }
}

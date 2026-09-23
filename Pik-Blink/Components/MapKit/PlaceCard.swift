//
//  PlaceCard.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI
internal import MapKit

struct PlaceCard: View {
    let place: SelectedPlace

    @State private var position: MapCameraPosition

    init(place: SelectedPlace) {
        self.place = place
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: place.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
            )
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text(place.name)
                .font(.headline)
                .foregroundStyle(.white)

            Text(place.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Map(position: $position, interactionModes: []) {
                Marker(place.name, coordinate: place.coordinate)
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 0.16, green: 0.16, blue: 0.18))
        )
        .onChange(of: place.id) { _ in
            position = .region(
                MKCoordinateRegion(
                    center: place.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
                )
            )
        }
    }
}

//
//  SelectedPlace.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

internal import MapKit

struct SelectedPlace: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

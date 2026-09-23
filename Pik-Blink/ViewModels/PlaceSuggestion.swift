//
//  PlaceSuggestion.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

internal import MapKit

struct PlaceSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

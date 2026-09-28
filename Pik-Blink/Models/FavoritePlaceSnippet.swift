//
//  FavoritePlaceSnippet.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import Foundation

struct FavoritePlaceSnippet: Identifiable, Hashable {
    let id = UUID()

    let label: String
    let name: String
    let address: String

    let latitude: Double
    let longitude: Double
}

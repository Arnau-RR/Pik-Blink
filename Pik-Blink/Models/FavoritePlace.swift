//
//  FavoritePlace.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import Foundation
import SwiftData

@Model
final class FavoritePlace {
    var label: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var createdAt: Date

    init(
        label: String,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.label = label
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = .now
    }
}

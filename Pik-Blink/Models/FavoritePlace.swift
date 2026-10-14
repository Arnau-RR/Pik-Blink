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
    var name: String = ""
    var label: String = ""
    var address: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var createdAt: Date = Date()

    init(name: String, label: String, address: String,
         latitude: Double, longitude: Double) {
        self.name = name
        self.label = label
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = Date()
    }
}

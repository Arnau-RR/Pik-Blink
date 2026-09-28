//
//  PlaceEntity.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//


import AppIntents

struct PlaceEntity: AppEntity, Identifiable {

    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Place"
    )

    static var defaultQuery = PlaceQuery()

    let id: String

    let title: String
    let subtitle: String

    let latitude: Double
    let longitude: Double

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(subtitle)"
        )
    }
}


//import AppIntents
//
//struct PlaceEntity: AppEntity, Identifiable {
//
//    static let typeDisplayRepresentation = TypeDisplayRepresentation(
//        name: "Place"
//    )
//
//    static var defaultQuery = PlaceQuery()
//
//    let id: String
//
//    let title: String
//    let subtitle: String
//
//    let latitude: Double
//    let longitude: Double
//
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(
//            title: "\(title)",
//            subtitle: "\(subtitle)"
//        )
//    }
//}

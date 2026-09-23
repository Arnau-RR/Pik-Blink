//
//  LocationSearchService.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI
internal import MapKit
import Combine

class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    @Published var query = "" {
        didSet { completer.queryFragment = query }
    }

    @Published var results: [MKLocalSearchCompletion] = []

    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
    
    func resolve(_ completion: MKLocalSearchCompletion) async throws -> SelectedPlace {
            let request = MKLocalSearch.Request(completion: completion)
            let response = try await MKLocalSearch(request: request).start()

            guard let item = response.mapItems.first else {
                throw NSError(domain: "Search", code: 0)
            }

            let placemark = item.placemark

            let address = [
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")

            return SelectedPlace(
                name: placemark.name ?? completion.title,
                address: address,
                coordinate: placemark.coordinate
            )
        }
}

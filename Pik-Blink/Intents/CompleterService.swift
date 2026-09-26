//
//  CompleterService.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import Foundation
internal import MapKit

@MainActor
final class CompleterService: NSObject, MKLocalSearchCompleterDelegate {

    private let completer = MKLocalSearchCompleter()
    private var continuation: CheckedContinuation<[MKLocalSearchCompletion], Error>?

    override init() {
        super.init()

        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .address]
    }

    func search(query: String) async throws -> [MKLocalSearchCompletion] {

        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            completer.queryFragment = query
        }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        continuation?.resume(returning: completer.results)
        continuation = nil
    }

    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

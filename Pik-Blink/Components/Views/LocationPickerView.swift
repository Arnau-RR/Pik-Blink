//
//  LocationPickerView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var search = LocationSearchService()

    var onSelect: (SelectedPlace) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(search.results, id: \.self) { item in
                    Button {
                        Task {
                            await selectPlace(item)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.headline)

                            if !item.subtitle.isEmpty {
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
            .searchable(
                text: $search.query,
                prompt: "location.picker.search.placeholder"
            )
            .navigationTitle("location.picker.navigation.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("location.picker.cancel.button") {
                        dismiss()
                    }
                }
            }
        }
    }

    @MainActor
    private func selectPlace(_ completion: MKLocalSearchCompletion) async {
        do {
            let place = try await search.resolve(completion)
            onSelect(place)
            dismiss()
        } catch {
            print("Error resolving place:", error)
        }
    }
}

#Preview {
    LocationPickerView { _ in }
}

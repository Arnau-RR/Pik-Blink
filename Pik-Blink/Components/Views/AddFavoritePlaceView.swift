//
//  AddFavoritePlaceView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import SwiftData

struct AddFavoritePlaceView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var label = ""
    @State private var selectedPlace: SelectedPlace?
    @State private var showLocationPicker = false

    private var canSave: Bool {
        !label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && selectedPlace != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Favorite name") {
                    TextField("Home", text: $label)
                }

                Section("Location") {
                    Button {
                        showLocationPicker = true
                    } label: {
                        if let place = selectedPlace {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(place.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        } else {
                            Label("Choose a location", systemImage: "mappin.and.ellipse")
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveFavorite()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView { place in
                    selectedPlace = place
                    if label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        label = place.name
                    }
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Save

    @MainActor
    private func saveFavorite() {
        guard let place = selectedPlace else { return }

        let name = place.name
        let address = place.address

        let descriptor = FetchDescriptor<FavoritePlace>(
            predicate: #Predicate<FavoritePlace> {
                $0.name == name && $0.address == address
            }
        )

        do {
            let exists = try context.fetch(descriptor)

            guard exists.isEmpty else {
                dismiss()
                return
            }

            let favorite = FavoritePlace(
                label: label.trimmingCharacters(in: .whitespacesAndNewlines),
                name: name,
                address: address,
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude
            )

            context.insert(favorite)
            try context.save()

            dismiss()

        } catch {
            print("Error saving favorite:", error)
        }
    }
}

#Preview {
    AddFavoritePlaceView()
}

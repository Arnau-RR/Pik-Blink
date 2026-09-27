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
                Section(String(localized: "settings.favoritePlaces.add.favoriteName.section")) {
                    TextField(String(localized: "settings.favoritePlaces.add.favoriteName.placeholder"), text: $label)
                }

                Section(String(localized: "settings.favoritePlaces.add.location.section")) {
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
                            Label(
                                String(localized: "settings.favoritePlaces.add.location.placeholder"),
                                systemImage: "mappin.and.ellipse"
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(String(localized: "settings.favoritePlaces.add.navigation.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(localized: "settings.favoritePlaces.add.cancel.button")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "settings.favoritePlaces.add.save.button")) {
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

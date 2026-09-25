import SwiftUI
import MapKit
import SwiftData

struct AddFavoritePlaceView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @StateObject private var search = PlaceSearchService()

    var body: some View {
        NavigationStack {
            List {
                ForEach(search.results, id: \.self) { item in
                    Button {
                        Task {
                            if let place = await search.resolve(item) {

                                let favorite = FavoritePlace(
                                    name: place.name,
                                    address: place.address,
                                    latitude: place.coordinate.latitude,
                                    longitude: place.coordinate.longitude
                                )

                                context.insert(favorite)
                                dismiss()
                            }
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
            .searchable(
                text: $search.query,
                prompt: "Search a place"
            )
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
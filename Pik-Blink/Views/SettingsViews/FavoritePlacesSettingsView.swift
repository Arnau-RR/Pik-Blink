import SwiftUI
import SwiftData

struct FavoritePlacesSettingsView: View {

    @Environment(\.modelContext) private var context

    @Query(sort: \FavoritePlace.name)
    private var places: [FavoritePlace]

    @State private var showAddPlace = false

    var body: some View {
        SettingsDetailView(title: "Favorite Places") {

            Section {
                ForEach(places) { place in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                            .font(.headline)

                        Text(place.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { context.delete(places[$0]) }
                }
            }

            Section {
                Button {
                    showAddPlace = true
                } label: {
                    Label("Add favorite place", systemImage: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showAddPlace) {
            AddFavoritePlaceView()
                .presentationDetents([.height(520)])
        }
    }
}
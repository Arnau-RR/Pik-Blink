import SwiftData

@Model
final class FavoritePlace {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double

    init(
        name: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
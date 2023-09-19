import UIKit
import Foundation
import RealmSwift

enum MediaType: String {
    case Movie = "movie"
    case Music = "music"
    case unknowned
}

class BookmarkModel: Object {
    @objc dynamic var trackId: String = ""
    @objc dynamic var type: String = MediaType.unknowned.rawValue
    @objc dynamic var artistName: String = ""
    @objc dynamic var collectionName: String = ""
    @objc dynamic var trackName: String = ""
    @objc dynamic var trackViewURL: String = ""
    @objc dynamic var thumbnailURL: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var trackTimeMillis: TimeInterval = 0
    @objc dynamic var longDescription: String = ""
    @objc dynamic var isLiked: Bool = false
    
    override static func primaryKey() -> String {
        return "trackId"
    }

    convenience init(trackId: String, type: MediaType, artistName: String, collectionName: String, trackName: String, trackViewURL: String, thumbnailURL: String, releaseDate: String, trackTimeMillis: TimeInterval, longDescription: String, isLiked: Bool) {
        self.init()
        self.trackId = trackId
        self.type = type.rawValue
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.trackViewURL = trackViewURL
        self.thumbnailURL = thumbnailURL
        self.releaseDate = releaseDate
        self.trackTimeMillis = trackTimeMillis
        self.longDescription = longDescription
        self.isLiked = isLiked
    }
}
extension BookmarkModel {
    var mediaType: MediaType {
        MediaType(rawValue: type) ?? .unknowned
    }
}

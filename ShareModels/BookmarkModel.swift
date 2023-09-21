import UIKit
import Foundation
import RealmSwift

public enum MediaType: String {
    case Movie = "movie"
    case Music = "music"
    case unknowned
}

public class BookmarkModel: Object {
    @objc dynamic public var trackId: String = ""
    @objc dynamic public var type: String = MediaType.unknowned.rawValue
    @objc dynamic public var artistName: String = ""
    @objc dynamic public var collectionName: String = ""
    @objc dynamic public var trackName: String = ""
    @objc dynamic public var trackViewURL: String = ""
    @objc dynamic public var thumbnailURL: String = ""
    @objc dynamic public var releaseDate: String = ""
    @objc dynamic public var trackTimeMillis: TimeInterval = 0
    @objc dynamic public var longDescription: String = ""
    @objc dynamic public var isLiked: Bool = false
    
    override public static func primaryKey() -> String {
        return "trackId"
    }

    convenience public init(trackId: String, type: MediaType, artistName: String, collectionName: String, trackName: String, trackViewURL: String, thumbnailURL: String, releaseDate: String, trackTimeMillis: TimeInterval, longDescription: String, isLiked: Bool) {
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
    public var mediaType: MediaType {
        MediaType(rawValue: type) ?? .unknowned
    }
}

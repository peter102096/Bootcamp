import Foundation
import ShareModels

extension MediaResultModel {
    var movieBookmarkModel: BookmarkModel {
        .init(
            trackId: String(trackID),
            type: .Movie,
            artistName: artistName,
            collectionName: collectionName ?? "",
            trackName: trackName,
            trackViewURL: trackViewURL,
            thumbnailURL: thumbnailURL,
            releaseDate: releaseDate,
            trackTimeMillis: trackTimeMillis ?? 0,
            longDescription: longDescription ?? "",
            isLiked: true)
    }
    
    var musicBookmarkModel: BookmarkModel {
        .init(
            trackId: String(trackID),
            type: .Music,
            artistName: artistName,
            collectionName: collectionName ?? "",
            trackName: trackName,
            trackViewURL: trackViewURL,
            thumbnailURL: thumbnailURL,
            releaseDate: releaseDate,
            trackTimeMillis: trackTimeMillis ?? 0,
            longDescription: longDescription ?? "",
            isLiked: true)
    }
}

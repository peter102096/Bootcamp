import Foundation
import ShareModels

extension MediaResultModel {
    var bookmarkModel: BookmarkModel {
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
}

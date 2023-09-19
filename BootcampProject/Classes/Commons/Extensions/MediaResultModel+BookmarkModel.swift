import Foundation

extension MovieResultModel {
    var bookmarkModel: BookmarkModel {
        .init(
            trackId: String(trackID),
            type: .Movie,
            artistName: artistName,
            collectionName: trackCensoredName ?? "",
            trackName: trackName,
            trackViewURL: trackViewURL,
            thumbnailURL: thumbnailURL,
            releaseDate: releaseDate,
            trackTimeMillis: trackTimeMillis ?? 0,
            longDescription: longDescription ?? "",
            isLiked: true)
    }
}

extension MusicResultModel {
    var bookmarkModel: BookmarkModel {
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
            longDescription: "",
            isLiked: true)
    }
}

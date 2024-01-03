import Foundation

extension MovieResultModel {
    var mediaResultModel: MediaResultModel {
        .init(
            trackID: trackID,
            artistName: artistName,
            collectionName: collectionName,
            trackName: trackName,
            trackViewURL: trackViewURL,
            thumbnailURL: thumbnailURL,
            releaseDate: releaseDate,
            trackTimeMillis: trackTimeMillis,
            longDescription: longDescription)
    }
}

extension MusicResultModel {
    var mediaResultModel: MediaResultModel {
        .init(
            trackID: trackID,
            artistName: artistName,
            collectionName: collectionName,
            trackName: trackName,
            trackViewURL: trackViewURL,
            thumbnailURL: thumbnailURL,
            releaseDate: releaseDate,
            trackTimeMillis: trackTimeMillis,
            longDescription: nil)
    }
}

import Foundation

// MARK: - MusicModel
struct MusicModel: Codable {
    let resultCount: Int
    let results: [MusicResultModel]

    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

// MARK: - MusicResult
struct MusicResultModel: Codable {
    let trackID: Int
    let artistName: String
    let trackName: String
    let collectionName: String?
    let trackViewURL: String
    let thumbnailURL: String
    let releaseDate: String
    let trackTimeMillis: TimeInterval?

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case trackName
        case collectionName
        case trackViewURL = "trackViewUrl"
        case thumbnailURL = "artworkUrl100"
        case releaseDate
        case trackTimeMillis
    }
}

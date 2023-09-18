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
    let collectionName: String?
    let trackName: String
    let trackViewURL: String
    let thumbnailURL: String
    let releaseDate: String
    let trackTimeMillis: Int?

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case collectionName
        case trackName
        case trackViewURL = "trackViewUrl"
        case thumbnailURL = "artworkUrl100"
        case releaseDate
        case trackTimeMillis
    }
}

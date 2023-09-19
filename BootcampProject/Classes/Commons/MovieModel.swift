import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let resultCount: Int
    let results: [MovieResultModel]
}
// MARK: - MovieResult
struct MovieResultModel: Codable {
    let trackID: Int
    let artistName: String
    let trackName: String
    let collectionName: String?
    let trackViewURL: String
    let thumbnailURL: String
    let releaseDate: String
    let trackTimeMillis: TimeInterval?
    let longDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case trackName
        case collectionName
        case trackViewURL = "trackViewUrl"
        case thumbnailURL = "artworkUrl100"
        case releaseDate
        case trackTimeMillis
        case longDescription
    }
}

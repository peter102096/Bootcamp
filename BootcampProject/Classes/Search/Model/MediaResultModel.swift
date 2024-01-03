import Foundation
import ShareModels

struct MediaResultModel {
    let trackID: Int
    let artistName: String
    let collectionName: String?
    let trackName: String
    let trackViewURL: String
    let thumbnailURL: String
    let releaseDate: String
    let trackTimeMillis: TimeInterval?
    let longDescription: String?
}

import Foundation

// MARK: - ErrorModel
struct ErrorModel: Codable, Error {
    let statusCode: Int
    let reason: String
}

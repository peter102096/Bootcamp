import Foundation

// MARK: - ErrorModel
struct ErrorModel: Codable {
    let statusCode: Int
    let reason: String
}

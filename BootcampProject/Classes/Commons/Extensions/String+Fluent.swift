import Foundation

extension String {
    var apiFormat: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

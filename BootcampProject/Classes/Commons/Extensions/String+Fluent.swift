import Foundation

extension String {
    var apiFormat: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    func localizedWithFormat(_ arguments: CVarArg...) -> String {
        String.localizedStringWithFormat(self, arguments)
    }
}

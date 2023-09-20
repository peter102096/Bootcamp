import Foundation

extension String {
    var apiFormat: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    func localizedWithFormat(_ argument: Int) -> String {
        let localized = localized()
        let formatterInt = NumberFormatter.localizedString(from: argument as NSNumber, number: .decimal)
        return String(format: localized, formatterInt)
    }
}

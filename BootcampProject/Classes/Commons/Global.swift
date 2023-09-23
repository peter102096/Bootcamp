struct Global {
    static var apiURL = "https://itunes.apple.com/search?term=%@&media=%@&country=%@"
    static var isDarkMode = false
    static var country: Country = .TW
}

enum Country: String {
    case US = "US"
    case TW = "TW"
    case JP = "JP"
    case SG = "SG"
    case KR = "KR"
}

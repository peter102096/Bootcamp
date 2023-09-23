import UIKit

class ShareDefaults: NSObject {
    static let shared = ShareDefaults()
    
    private let KEY_APPEARANCE = "appearance"

    private let KEY_COUNTRY = "country"

    private var user:UserDefaults
    
    private override init() {
        user = UserDefaults()
        super.init()
    }

    func setDarkMode(_ isDarkMode: Bool, completion: @escaping (Bool) -> Void) {
        user.set(isDarkMode, forKey: KEY_APPEARANCE)
        completion(user.synchronize())
    }

    var isDarkMode: Bool {
        guard let isDarkMode = user.object(forKey: KEY_APPEARANCE) as? Bool else {
            return UIViewController().traitCollection.userInterfaceStyle == .dark
        }
        return isDarkMode
    }

    func setSearchCountry(_ country: String, completion: @escaping (Bool) -> Void) {
        user.set(country, forKey: KEY_COUNTRY)
        completion(user.synchronize())
    }

    var getCountry: String {
        guard let country = user.object(forKey: KEY_COUNTRY) as? String else {
            return Country.TW.rawValue
        }
        return country
    }
}

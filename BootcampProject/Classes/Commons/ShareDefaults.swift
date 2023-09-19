import UIKit

class ShareDefaults: NSObject {
    static let shared = ShareDefaults()
    
    private let KEY_APPEARANCE = "appearance"

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
}

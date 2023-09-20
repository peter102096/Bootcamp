import UIKit

class MainNavController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        Global.isDarkMode ? .lightContent: .darkContent
    }
}

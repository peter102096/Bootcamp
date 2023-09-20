import UIKit

class MainTabBarController: UITabBarController {
    let searchVC = SearchViewController(nibName: Key.SEARCH_VC, bundle: nil)
    let userVC = UserViewController(nibName: Key.USER_VC, bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers?.removeAll()
        viewControllers?.append(searchVC)
        viewControllers?.append(userVC)
        
        searchVC.tabBarItem.image = .searchIcon
        userVC.tabBarItem.image = .personIcon
    }

}

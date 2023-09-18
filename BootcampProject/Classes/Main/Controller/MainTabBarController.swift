import UIKit

class MainTabBarController: UITabBarController {
    let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
    let userVC = UserViewController(nibName: "UserViewController", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers?.removeAll()
        viewControllers?.append(searchVC)
        viewControllers?.append(userVC)
        
        searchVC.tabBarItem.image = .searchIcon
        userVC.tabBarItem.image = .personIcon
    }

}

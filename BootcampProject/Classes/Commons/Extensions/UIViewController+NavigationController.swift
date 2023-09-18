import UIKit
import RxSwift

public extension UIViewController {
    func pushViewController(_ vc: UIViewController) {
        tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    func popViewController() {
        tabBarController?.navigationController?.popViewController(animated: true)
    }
    func popToRootViewController() {
        tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
    func popToViewController(_ vc: UIViewController) {
        tabBarController?.navigationController?.popToViewController(vc, animated: true)
    }
}

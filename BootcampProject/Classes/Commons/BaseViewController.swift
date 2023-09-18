import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {

    private let loadingView = JGProgressHUD()

    private let expectionAlert: UIAlertController = .init(title: "Error", message: "something expection error", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        expectionAlert.addAction(.init(title: "關閉", style: .cancel))
        setupUI()
        bindingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAppearance()
    }

    open func setupUI() {
        
    }

    open func bindingView() {
    }

    open func updateAppearance() {
        view.backgroundColor = Global.isDarkMode ? .darkModeBgColor: .lightModeBgColor
        tabBarController?.navigationController?.navigationBar.tintColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        tabBarController?.navigationController?.navigationBar.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        tabBarController?.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Global.isDarkMode ? UIColor.darkModeTxtColor! : UIColor.lightModeTxtColor!]
        
        tabBarController?.setNeedsStatusBarAppearanceUpdate()
    }

    func showLoadingView(in view: UIView) {
        loadingView.show(in: view)
    }

    func dismissLoadingView() {
        loadingView.dismiss(animated: true)
    }

    func showExceptionErrorAlert(message errorMsg: String) {
        expectionAlert.message = errorMsg
        present(expectionAlert, animated: true)
    }

    func dismissExceptionErrorAlert() {
        expectionAlert.dismiss(animated: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 模擬器正常，實機有出入
//        if UIApplication.shared.applicationState == .active {
//            ShareDefaults.shared.setAppearance(isDarkMode: traitCollection.userInterfaceStyle == .dark, completion: { [weak self] success in
//                Global.isDarkMode = self?.traitCollection.userInterfaceStyle == .dark
//                self?.updateAppearance()
//            })
//        }
    }
}
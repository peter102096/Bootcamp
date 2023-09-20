import UIKit
import JGProgressHUD
import RxCocoa
import RxSwift

enum LoadViewStyle {
    case Normal
    case WithCancelBtn
    case Unknowned
}

class BaseViewController: UIViewController {

    private let loadingViewWithCancelBtn = CustomLoadingView()
    private let loadingView = JGProgressHUD(style: Global.isDarkMode ? .dark : .light)

    private let expectionAlert: UIAlertController = .init(title: "Error".localized(), message: "ExpectionError".localized(), preferredStyle: .alert)

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        expectionAlert.addAction(.init(title: "Confirm".localized(), style: .cancel))
        setupUI()
        bindView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAppearance()
    }

    open func setupUI() {}

    open func bindView() {
        loadingViewWithCancelBtn.cancelBtnClicked
            .subscribe(onNext: { [weak self] in
                self?.loadingCancelBtnClicked()
            })
            .disposed(by: disposeBag)
    }

    open func bindViewModel() {}

    open func loadingCancelBtnClicked() {}

    open func updateAppearance() {
        loadingViewWithCancelBtn.updateStyle(Global.isDarkMode ? .dark : .light)
        loadingView.style = Global.isDarkMode ? .dark : .light

        tabBarController?.tabBar.tintColor = Global.isDarkMode ? ._EEEEF0 : ._1C1C20
        tabBarController?.tabBar.unselectedItemTintColor = Global.isDarkMode ? ._5B5B60 : ._B9B9B9

        view.backgroundColor = Global.isDarkMode ? .darkModeBgColor: .lightModeBgColor
        tabBarController?.navigationController?.navigationBar.tintColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        tabBarController?.navigationController?.navigationBar.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        tabBarController?.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Global.isDarkMode ? UIColor.darkModeTxtColor! : UIColor.lightModeTxtColor!]
        
        tabBarController?.setNeedsStatusBarAppearanceUpdate()
    }

    func showLoadingView(in view: UIView?, style: LoadViewStyle) {
        if view == nil { return }
        switch style {
        case .Normal:
            loadingView.show(in: view!)
        case .WithCancelBtn:
            loadingViewWithCancelBtn.show(in: view!)
        case .Unknowned:
            return
        }
    }

    func dismissLoadingView() {
        loadingView.dismiss(animated: true)
        loadingViewWithCancelBtn.dismiss(animated: true)
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

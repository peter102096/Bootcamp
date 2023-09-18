import UIKit
import RxSwift
import RxCocoa
import SnapKit

class UserViewController: BaseViewController {

    lazy var themeColorTitleLabel: UILabel = {
        UILabel()
            .setText("主題顏色")
            .setTextAlignment(.left)
            .setFont(UIFont.boldSystemFont(ofSize: 17))
    }()

    lazy var themeButton: UIButton = {
        UIButton(type: .system)
            .setTitle("深色主題")
            .setContentMode(.scaleAspectFit)
            .setImage(.rightIcon)
            .setSemanticContent(.forceRightToLeft)
    }()

    lazy var bookmarkTitleLabel: UILabel = {
        UILabel()
            .setText("收藏項目")
            .setTextAlignment(.left)
            .setFont(UIFont.boldSystemFont(ofSize: 17))
    }()

    lazy var bookmarkButton: UIButton = {
        UIButton(type: .system)
            .setTitle("共有 1,672 項收藏")
            .setContentMode(.scaleAspectFit)
            .setImage(.rightIcon)
            .setSemanticContent(.forceRightToLeft)
    }()

    lazy var aboutAppleButton: UIButton = {
        UIButton(type: .system)
            .setTitle("關於Apple iTunes")
            .setFont(.boldSystemFont(ofSize: 17))
            .setContentMode(.scaleAspectFit)
            .setImage(.questionIcon)
    }()

    lazy var viewModel: UserViewModel = {
        UserViewModel()
    }()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "個人資料"
    }

    override func setupUI() {
        view.addSubview(themeColorTitleLabel)
        themeColorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(themeButton)
        themeButton.snp.makeConstraints {
            $0.top.equalTo(themeColorTitleLabel.snp.top).inset(2)
            $0.bottom.equalTo(themeColorTitleLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualTo(themeColorTitleLabel.snp.trailing).inset(16)
        }

        view.addSubview(bookmarkTitleLabel)
        bookmarkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(themeColorTitleLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(bookmarkTitleLabel.snp.top).inset(2)
            $0.bottom.equalTo(bookmarkTitleLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualTo(bookmarkTitleLabel.snp.trailing).inset(16)
        }

        view.addSubview(aboutAppleButton)
        aboutAppleButton.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(36)
            $0.trailing.equalToSuperview().inset(16)
        }
        super.setupUI()
    }

    override func bindingView() {
        themeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showAlert()
            }
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .subscribe { [weak self] _ in
                let vc = BookmarkViewController(nibName: "BookmarkViewController", bundle: nil)
                self?.pushViewController(vc)
            }
            .disposed(by: disposeBag)

        aboutAppleButton.rx.tap
            .subscribe { [weak self] _ in
                let vc = WebViewController(nibName: "WebViewController", bundle: nil)
                self?.pushViewController(vc)
            }
            .disposed(by: disposeBag)
    }

    override func updateAppearance() {
        super.updateAppearance()
        debugPrint("User", "updateAppearance")
        themeButton.setTitle(Global.isDarkMode ? "深色主題" : "淺色主題")

        themeColorTitleLabel.setTextColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        themeButton
            .setTintColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        bookmarkTitleLabel
            .setTextColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        bookmarkButton
            .setTintColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        aboutAppleButton
            .setTintColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)
    }

    private func showAlert() {
        let alert = UIAlertController(title: "主題顏色", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "深色主題", style: .default, handler: { [weak self] _ in
            self?.updateAppearanceWithShareDefault(true)
        }))
        alert.addAction(.init(title: "淺色主題", style: .default, handler: { [weak self] _ in
            self?.updateAppearanceWithShareDefault(false)
        }))
        alert.addAction(.init(title: "取消", style: .cancel))
        present(alert, animated: true)
    }

    private func updateAppearanceWithShareDefault(_ isDarkMode: Bool) {
        ShareDefaults.shared.setAppearance(isDarkMode: isDarkMode) { [weak self] isSuccess in
            if isSuccess {
                Global.isDarkMode = isDarkMode
                DispatchQueue.main.async { [weak self] in
                    self?.updateAppearance()
                }
            } else {
                self?.showExceptionErrorAlert(message: "something error")
            }
        }
    }
}
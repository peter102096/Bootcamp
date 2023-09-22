import UIKit
import RxSwift
import RxCocoa
import SnapKit

class UserViewController: BaseViewController {

    lazy var themeColorTitleLabel: UILabel = {
        UILabel()
            .setText("ThemeColor".localized())
            .setTextAlignment(.left)
            .setFont(UIFont.boldSystemFont(ofSize: 17))
    }()

    lazy var themeButton: UIButton = {
        UIButton(type: .system)
            .setTitle("DarkTheme".localized())
            .setContentMode(.scaleAspectFit)
            .setImage(.rightIcon)
            .setSemanticContent(.forceRightToLeft)
    }()

    lazy var bookmarkTitleLabel: UILabel = {
        UILabel()
            .setText("FavoriteItem".localized())
            .setTextAlignment(.left)
            .setFont(UIFont.boldSystemFont(ofSize: 17))
    }()

    lazy var bookmarkButton: UIButton = {
        UIButton(type: .system)
            .setTitle("ShareFavoritesFormat".localizedWithFormat(1000))
            .setContentMode(.scaleAspectFit)
            .setImage(.rightIcon)
            .setSemanticContent(.forceRightToLeft)
    }()

    lazy var aboutAppleButton: UIButton = {
        UIButton(type: .system)
            .setTitle("AboutiTunes".localized())
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
        tabBarController?.title = "UserInfo".localized()
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

    override func bindView() {
        super.bindView()
        themeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showThemeActionSheet()
            }
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .subscribe { [weak self] _ in
                let vc = BookmarkViewController(nibName: Key.BOOKMARK_VC, bundle: nil)
                self?.pushViewController(vc)
            }
            .disposed(by: disposeBag)

        aboutAppleButton.rx.tap
            .subscribe { [weak self] _ in
                let vc = AboutiTunesViewController(nibName: Key.WEBVIEW_VC, bundle: nil)
                self?.pushViewController(vc)
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                self?.showLoadingView(in: self?.view, style: .Normal)
            })
            .disposed(by: disposeBag)
    }

    override func bindViewModel() {
        rx.viewDidAppear
            .mapToVoid()
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)

        viewModel.output.bookmarksCount
            .drive(onNext: { [weak self] (count) in
                self?.dismissLoadingView()
                DispatchQueue.main.async {
                    self?.bookmarkButton.setTitle("ShareFavoritesFormat".localizedWithFormat(count + 1000))
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.setThemeModeSucceed
            .drive(onNext: { [weak self] (isSucceed) in
                DispatchQueue.main.async {
                    if isSucceed {
                        self?.updateAppearance()
                    } else {
                        self?.showExceptionErrorAlert(message: "ExpectionError".localized())
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    override func updateAppearance() {
        super.updateAppearance()
        themeButton.setTitle(Global.isDarkMode ? "DarkTheme".localized() : "LightTheme".localized())

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

    private func showThemeActionSheet() {
        let alert = UIAlertController(title: "ThemeColor".localized(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "DarkTheme".localized(), style: .default, handler: { [weak self] _ in
            self?.viewModel.input.isDarkMode.onNext(true)
        }))
        alert.addAction(.init(title: "LightTheme".localized(), style: .default, handler: { [weak self] _ in
            self?.viewModel.input.isDarkMode.onNext(false)
        }))
        alert.addAction(.init(title: "Cancel".localized(), style: .cancel))
        present(alert, animated: true)
    }
}

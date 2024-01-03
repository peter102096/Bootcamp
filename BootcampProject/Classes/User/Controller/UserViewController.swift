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

    lazy var countryTitleLabel: UILabel = {
        UILabel()
            .setText("SearchCountry".localized())
            .setTextAlignment(.left)
            .setFont(UIFont.boldSystemFont(ofSize: 17))
    }()

    lazy var countryButton: UIButton = {
        UIButton(type: .system)
            .setTitle(Country.TW.rawValue.localized())
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

        view.addSubview(countryTitleLabel)
        countryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkTitleLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(countryButton)
        countryButton.snp.makeConstraints {
            $0.top.equalTo(countryTitleLabel.snp.top).inset(2)
            $0.bottom.equalTo(countryTitleLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualTo(countryTitleLabel.snp.trailing).inset(16)
        }

        view.addSubview(aboutAppleButton)
        aboutAppleButton.snp.makeConstraints {
            $0.top.equalTo(countryButton.snp.bottom).offset(36)
            $0.trailing.equalToSuperview().inset(16)
        }
        super.setupUI()
    }

    override func bindViews() {
        super.bindViews()
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

        countryButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showCountryActionSheet()
            })
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
                        self?.showExceptionErrorAlert(message: "SettingFailed".localized())
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.setCountrySucceed
            .drive(onNext: { [weak self] (isSucceed) in
                DispatchQueue.main.async {
                    if isSucceed {
                        self?.updateAppearance()
                    } else {
                        self?.showExceptionErrorAlert(message: "SettingFailed".localized())
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    override func updateAppearance() {
        super.updateAppearance()
        themeButton.setTitle(Global.isDarkMode ? "DarkTheme".localized() : "LightTheme".localized())

        countryButton.setTitle(Global.country.rawValue.localized())

        themeColorTitleLabel.setTextColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        themeButton
            .setTintColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        bookmarkTitleLabel
            .setTextColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        bookmarkButton
            .setTintColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        countryTitleLabel
            .setTextColor(Global.isDarkMode ? .darkModeTxtColor: .lightModeTxtColor)

        countryButton
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

    private func showCountryActionSheet() {
        let alert = UIAlertController(title: "SearchCountry".localized(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "US".localized(), style: .default, handler: { [weak self] _ in
            self?.setCountry(.US)
        }))
        alert.addAction(.init(title: "TW".localized(), style: .default, handler: { [weak self] _ in
            self?.setCountry(.TW)
        }))
        alert.addAction(.init(title: "JP".localized(), style: .default, handler: { [weak self] _ in
            self?.setCountry(.JP)
        }))
        alert.addAction(.init(title: "SG".localized(), style: .default, handler: { [weak self] _ in
            self?.setCountry(.SG)
        }))
        alert.addAction(.init(title: "KR".localized(), style: .default, handler: { [weak self] _ in
            self?.setCountry(.KR)
        }))
        alert.addAction(.init(title: "Cancel".localized(), style: .cancel))
        present(alert, animated: true)
    }

    private func setCountry(_ country: Country) {
        viewModel.input.country.onNext(country)
    }
}

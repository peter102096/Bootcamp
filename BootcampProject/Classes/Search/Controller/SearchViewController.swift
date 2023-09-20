import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: BaseViewController {

    lazy var searchBar: UISearchBar = {
        UISearchBar()
            .setPlaceHolder("PleaseEnterKeyword".localized())
    }()

    lazy var searchResultTableView: UITableView = {
        UITableView()
            .setRegister(UINib(nibName: Key.MUSIC_CELL, bundle: nil), forCellReuseIdentifier: Key.MUSIC_CELL)
            .setRegister(UINib(nibName: Key.MOVIE_CELL, bundle: nil), forCellReuseIdentifier: Key.MOVIE_CELL)
            .setSeparatorStyle(.none)
            .setTableFooterView(.init())
            .setDelaysContentTouches(false)
            .setDataSource(self)
            .setDelegate(self)
    }()

    lazy var viewModel = SearchViewModel()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Search".localized()
    }

    override func setupUI() {
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(6)
        }
        view.addSubview(searchResultTableView)

        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).inset(6)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
        super.setupUI()
    }

    override func bindView() {
        super.bindView()

        rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                self?.showLoadingView(in: self?.view, style: .Normal)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe (onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidEndEditing
            .subscribe(onNext: { [weak self] _ in
                if let keyword = self?.searchBar.text {
                    if keyword.isEmpty {
                        self?.showEmptyAlert()
                    } else {
                        self?.showLoadingView(in: self?.view, style: .WithCancelBtn)
                        self?.viewModel.input.keyword.onNext(keyword)
                    }
                    
                }
            })
            .disposed(by: disposeBag)
    }

    override func bindViewModel() {

        rx.viewDidAppear
            .mapToVoid()
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)

        viewModel.output.searchResult
            .drive(onNext: { [weak self] result in
                self?.dismissLoadingView()
                if let self = self, result[Key.MUSIC] is MusicModel, result[Key.MOVIE] is MovieModel {
                    DispatchQueue.main.async {
                        self.searchResultTableView.reloadData()
                        self.searchResultTableView.scrollRectToVisible(.init(x: 0, y: 0, width: 1, height: 1), animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.bookmarksResult
            .drive (onNext: { [weak self] (result) in
                self?.searchResultTableView.reloadData()
                self?.dismissLoadingView()
            })
            .disposed(by: disposeBag)
    }

    override func loadingCancelBtnClicked() {
        viewModel.input.cancelRequest.onNext(())
        dismissLoadingView()
    }

    override func updateAppearance() {
        super.updateAppearance()

        searchResultTableView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        searchResultTableView.reloadData()

        searchBar.searchTextField.backgroundColor = Global.isDarkMode ? ._1C1C20 : ._EEEEF0
        searchBar.searchBarStyle = .minimal
        
        searchBar.searchTextField.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        searchBar.searchTextField.leftView?.tintColor = Global.isDarkMode ? ._8B8B92 : ._B9B9B9
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "PleaseEnterKeyword".localized(), attributes: [.foregroundColor: Global.isDarkMode ? UIColor._8B8B92! : UIColor._B9B9B9!])
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton")as? UIButton {
            if let clearBtnImg = clearButton.image(for: .highlighted) {
                clearButton.isHidden = false
                let tintedClearImage = clearBtnImg.withTintColor(Global.isDarkMode ? ._8B8B92! : ._B9B9B9!)
                clearButton.setImage(tintedClearImage, for: .normal)
            } else {
                clearButton.isHidden = true
            }
        }
    }

    private func showEmptyAlert() {
        let alert = UIAlertController(title: "Error".localized(), message: "KeywordNotEmpty".localized(), preferredStyle: .alert)
        alert.addAction(.init(title: "Confirm".localized(), style: .cancel))
        present(alert, animated: true)
    }

}

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: BaseViewController {

    lazy var searchBar: UISearchBar = {
        UISearchBar()
            .setPlaceHolder("請輸入關鍵字")
    }()

    lazy var searchResultTableView: UITableView = {
        UITableView()
            .setRegister(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicTableViewCell")
            .setRegister(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
            .setSeparatorStyle(.none)
            .setTableFooterView(.init())
            .setDelaysContentTouches(false)
            .setDataSource(self)
            .setDelegate(self)
    }()

    lazy var viewModel = SearchViewModel()

    lazy var bookmarkList: [BookmarkModel] = []

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "搜尋"
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBookmarks()
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

    override func bindingView() {
        searchBar.rx.searchButtonClicked
            .subscribe { [weak self] _ in
                if let self = self {
                    self.searchBar.resignFirstResponder()
                    self.showLoadingView(in: self.view)
                    self.viewModel.input.keyword.onNext(self.searchBar.text!)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output.searchResult
            .drive(onNext: { [weak self] result in
                self?.dismissLoadingView()
                if let self = self, result["Music"] is MusicModel, result["Movie"] is MovieModel {
                    DispatchQueue.main.async {
                        self.searchResultTableView.reloadData()
                        self.searchResultTableView.scrollRectToVisible(.init(x: 0, y: 0, width: 1, height: 1), animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    override func updateAppearance() {
        super.updateAppearance()
        searchResultTableView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        searchResultTableView.reloadData()

        searchBar.searchTextField.backgroundColor = Global.isDarkMode ? ._1C1C20 : ._EEEEF0
        searchBar.searchBarStyle = .minimal
        
        searchBar.searchTextField.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        searchBar.searchTextField.leftView?.tintColor = Global.isDarkMode ? ._8B8B92 : ._B9B9B9
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "請輸入關鍵字", attributes: [.foregroundColor: Global.isDarkMode ? UIColor._8B8B92! : UIColor._B9B9B9!])
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton")as? UIButton {
            if let clearBtnImg = clearButton.image(for: .highlighted) {
                clearButton.isHidden = false
                let tintedClearImage = clearBtnImg.withTintColor(Global.isDarkMode ? ._8B8B92! : ._B9B9B9!)
                clearButton.setImage(tintedClearImage, for: .normal)
            }else{
                clearButton.isHidden = true
            }
        }
    }

    internal func getBookmarks() {
        showLoadingView(in: view)
        DBModel.shared.getBookmarks { [weak self] in
            self?.bookmarkList = $0
            self?.searchResultTableView.reloadData()
            self?.dismissLoadingView()
        }
    }
}

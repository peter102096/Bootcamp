import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BookmarkViewController: BaseViewController {

    lazy var mediaTypeSegmentControl: UISegmentedControl = {
        UISegmentedControl()
            .insertSegment("Movie".localized())
            .insertSegment("Music".localized())
            .selectedSegmentIndex(0)
    }()
    
    lazy var bookmarksTableView: UITableView = {
        UITableView()
            .setRegister(UINib(nibName: Key.MUSIC_CELL, bundle: nil), forCellReuseIdentifier: Key.MUSIC_CELL)
            .setRegister(UINib(nibName: Key.MOVIE_CELL, bundle: nil), forCellReuseIdentifier: Key.MOVIE_CELL)
            .setSeparatorStyle(.none)
            .setTableFooterView(.init())
            .setDelaysContentTouches(false)
            .setDataSource(self)
            .setDelegate(self)
    }()

    internal var moveieBookmarksList: [BookmarkModel] = []
    internal var musicBookmarksList: [BookmarkModel] = []

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBookmarks()
    }

    override func setupUI() {
        view.addSubview(mediaTypeSegmentControl)
        mediaTypeSegmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(6)
        }

        view.addSubview(bookmarksTableView)
        bookmarksTableView.snp.makeConstraints {
            $0.top.equalTo(mediaTypeSegmentControl.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }

    override func bindView() {
        mediaTypeSegmentControl.rx.selectedSegmentIndex
            .subscribe { [weak self] _ in
                self?.bookmarksTableView.reloadData()
            }
            .disposed(by: disposeBag)
    }

    override func updateAppearance() {
        super.updateAppearance()
        navigationController?.navigationBar.tintColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        navigationController?.navigationBar.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        bookmarksTableView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        bookmarksTableView.reloadData()

        mediaTypeSegmentControl.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        mediaTypeSegmentControl.tintColor = Global.isDarkMode ? ._1C1C20 : ._EEEEF0
        mediaTypeSegmentControl.selectedSegmentTintColor = Global.isDarkMode ? ._5B5B60 : .white
        mediaTypeSegmentControl.setTitleTextAttributes([.foregroundColor: Global.isDarkMode ? UIColor.darkModeTxtColor! : UIColor.lightModeTxtColor!], for: .normal)
    }

    internal func getBookmarks() {
        showLoadingView(in: view, style: .Normal)
        DBModel.shared.getBookmarks { [weak self] result in
            self?.dismissLoadingView()
            let totalBookmarks = result
            self?.moveieBookmarksList = totalBookmarks.filter({ $0.mediaType == .Movie })
            self?.musicBookmarksList = totalBookmarks.filter({ $0.mediaType == .Music })
            DispatchQueue.main.async { [weak self] in
                self?.bookmarksTableView.reloadData()
            }
        }
    }
}

import RxCocoa
import RxSwift
import ShareModels

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String?>()

    private let cancelRequest = PublishSubject<Void>()

    private var apiErrorModel = PublishRelay<ErrorModel>()

    private(set) var movieSearchResult = BehaviorRelay<[MovieResultModel]>(value: .init([]))

    private(set) var musicSearchResult = BehaviorRelay<[MusicResultModel]>(value: .init([]))

    private(set) var bookmarkList: BehaviorRelay<[BookmarkModel]> = .init(value: [])

    private let disposeBag = DisposeBag()

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override init() {
        super.init()

        let keywordIsEmpty: Observable<Bool> = keyword.flatMapLatest { [unowned self] in
            let isEmpty = checkKeyword($0)
            if !isEmpty {
                getSearchResult($0!)
            }
            return Observable.just(isEmpty)
        }

        refresh
            .subscribe(onNext: { [weak self] in
                self?.getBookmarks()
            })
            .disposed(by: disposeBag)

        cancelRequest
            .subscribe(onNext: {
                APIModel.shared.cancelAllRequest()
            })
            .disposed(by: disposeBag)

        input = .init(
            refresh: self.refresh.asObserver(),
            keyword: self.keyword.asObserver(),
            cancelRequest: self.cancelRequest.asObserver())

        output = .init(
            keywordIsEmpty: keywordIsEmpty.asDriver(onErrorJustReturn: true),
            getDataError: apiErrorModel.asDriver(onErrorJustReturn: .init(statusCode: 404, reason: "ExpectionError")),
            movieSearchResult: movieSearchResult.asDriver(),
            musicSearchResult: musicSearchResult.asDriver(),
            bookmarksResult: bookmarkList.asDriver())
    }

    private func checkKeyword(_ keyword: String?) -> Bool {
        if let keyword = keyword {
            return keyword.isEmpty
        }
        return true
    }

    private func getSearchResult(_ keyword: String) {
        let movieUrl = String(format: Global.apiURL, arguments: [keyword, Key.MOVIE, Global.country.rawValue]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let musicUrl = String(format: Global.apiURL, arguments: [keyword, Key.MUSIC, Global.country.rawValue]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        APIModel.shared.getMovie(url: movieUrl) { [weak self] statusCode, result in
            if let movieModel = result as? MovieModel {
                self?.movieSearchResult.accept(movieModel.results)
            }
            if let errorModel = result as? ErrorModel {
                self?.apiErrorModel.accept(errorModel)
            }
        }

        APIModel.shared.getMusic(url: musicUrl) { [weak self] statusCode, result in
            if statusCode == 200, let musicModel = result as? MusicModel {
                self?.musicSearchResult.accept(musicModel.results)
            }
            if let errorModel = result as? ErrorModel {
                self?.apiErrorModel.accept(errorModel)
            }
        }
    }

    private func getBookmarks() {
        DBModel.shared.getBookmarks { [weak self] (bookmarks) in
            self?.bookmarkList.accept(bookmarks)
        }
    }
}
extension SearchViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
        let keyword: AnyObserver<String?>
        let cancelRequest: AnyObserver<Void>
    }

    struct Output {
        let keywordIsEmpty: Driver<Bool>
        let getDataError: Driver<ErrorModel>
        let movieSearchResult: Driver<[MovieResultModel]>
        let musicSearchResult: Driver<[MusicResultModel]>
        let bookmarksResult: Driver<[BookmarkModel]>
    }
}

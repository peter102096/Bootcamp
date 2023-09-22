import RxCocoa
import RxSwift
import ShareModels

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String?>()

    private let cancelRequest = PublishSubject<Void>()

    private(set) var movieSearchResult = BehaviorRelay<[MovieResultModel]>(value: .init([]))

    private(set) var musicSearchResult = BehaviorRelay<[MusicResultModel]>(value: .init([]))

    private(set) var bookmarkList: BehaviorRelay<[BookmarkModel]> = .init(value: [])

    private let disposeBag = DisposeBag()

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

        APIModel.shared.getMovie(keyword) { [weak self] statusCode, result in
            if statusCode == 200, let movieModel = result as? MovieModel {
                self?.movieSearchResult.accept(movieModel.results)
            }
        }

        APIModel.shared.getMusic(keyword) { [weak self] statusCode, result in
            if statusCode == 200, let musicModel = result as? MusicModel {
                self?.musicSearchResult.accept(musicModel.results)
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
        let movieSearchResult: Driver<[MovieResultModel]>
        let musicSearchResult: Driver<[MusicResultModel]>
        let bookmarksResult: Driver<[BookmarkModel]>
    }
}

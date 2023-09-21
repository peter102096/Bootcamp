import RxCocoa
import RxSwift
import ShareModels

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String>()

    private let cancelRequest = PublishSubject<Void>()

    private(set) var movieSearchResult = BehaviorRelay<MovieModel?>(value: .init(resultCount: 0, results: []))

    private(set) var musicSearchResult = BehaviorRelay<MusicModel?>(value: .init(resultCount: 0, results: []))

    private(set) var bookmarkList: BehaviorRelay<[BookmarkModel]> = .init(value: [])

    private let disposeBag = DisposeBag()

//    public let group = DispatchGroup()

    override init() {
        super.init()

        keyword
            .subscribe(onNext: { [weak self] in
                self?.getSearchResult($0)
            })
            .disposed(by: disposeBag)

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
            movieSearchResult: movieSearchResult.asDriver(),
            musicSearchResult: musicSearchResult.asDriver(),
            bookmarksResult: bookmarkList.asDriver())
    }

    private func getSearchResult(_ keyword: String) {

        APIModel.shared.getMovie(keyword) { [weak self] statusCode, result in
            if statusCode == 200, let movieModel = result as? MovieModel {
                self?.movieSearchResult.accept(movieModel)
            }
        }

        APIModel.shared.getMusic(keyword) { [weak self] statusCode, result in
            if statusCode == 200, let musicModel = result as? MusicModel {
                self?.musicSearchResult.accept(musicModel)
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
        let keyword: AnyObserver<String>
        let cancelRequest: AnyObserver<Void>
    }

    struct Output {
        let movieSearchResult: Driver<MovieModel?>
        let musicSearchResult: Driver<MusicModel?>
        let bookmarksResult: Driver<[BookmarkModel]>
    }
}

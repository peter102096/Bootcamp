import RxCocoa
import RxSwift

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String>()

    private let cancelRequest = PublishSubject<Void>()

    private(set) var searchResult = BehaviorRelay<Dictionary<String, Codable?>>(value: [Key.MOVIE: nil, Key.MUSIC: nil])

    private(set) var bookmarkList: BehaviorRelay<[BookmarkModel]> = .init(value: [])

    private var cancelFlag = false

    private let disposeBag = DisposeBag()

    private let group = DispatchGroup()

    override init() {
        super.init()

        keyword
            .subscribe(onNext: { [weak self] in
                self?.getSearchResult($0)
            })
            .disposed(by: disposeBag)

        let bookmarks = refresh.flatMapLatest { [weak self] in
            self?.getBookmarks() ?? .empty()
        }.asDriver(onErrorJustReturn: [])

        cancelRequest
            .subscribe(onNext: { [weak self] in
                self?.cancelFlag = true
                APIModel.shared.cancelAllRequest()
            })
            .disposed(by: disposeBag)
        
        input = .init(
            refresh: self.refresh.asObserver(),
            keyword: self.keyword.asObserver(),
            cancelRequest: self.cancelRequest.asObserver())

        output = .init(
            searchResult: self.searchResult.asDriver(),
            bookmarksResult: bookmarks)
    }

    private func getSearchResult(_ keyword: String) {
        var tmpSearchResult: Dictionary<String, Codable?> = [Key.MOVIE: nil, Key.MUSIC: nil]
        group.enter()
        DispatchQueue(label: "getMovieQueue", attributes: .concurrent).async {
            APIModel.shared.getMovie(keyword) { [weak self] statusCode, result in
                if statusCode == 200, result is MovieModel {
                    tmpSearchResult.updateValue(result, forKey: Key.MOVIE)
                }
                self?.group.leave()
            }
        }

        group.enter()
        DispatchQueue(label: "getMusicQueue", attributes: .concurrent).async {
            APIModel.shared.getMusic(keyword) { [weak self] statusCode, result in
                if statusCode == 200, result is MusicModel {
                    tmpSearchResult.updateValue(result, forKey: Key.MUSIC)
                }
                self?.group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            if let self = self {
                self.cancelFlag ? self.cancelFlag.toggle() : self.searchResult.accept(tmpSearchResult)
            }
        }
    }

    private func getBookmarks() -> Observable<[BookmarkModel]> {
        Observable.create { observer in
            DBModel.shared.getBookmarks { [weak self] (bookmarks) in
                self?.bookmarkList.accept(bookmarks)
                observer.onNext(bookmarks)
                observer.onCompleted()
            }
            return Disposables.create()
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
        let searchResult: Driver<Dictionary<String, Codable?>>
        let bookmarksResult: Driver<[BookmarkModel]>
    }
}

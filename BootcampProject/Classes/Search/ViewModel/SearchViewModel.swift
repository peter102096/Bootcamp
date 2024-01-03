import RxCocoa
import RxSwift
import ShareModels

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String?>()

    private let cancelRequest = PublishSubject<Void>()
    
    private(set) var searchResult = BehaviorRelay<[MediaType: [MediaResultModel]]>(value: [.Movie:[], .Music: []])
    
    private var searchError: PublishRelay<ErrorModel> = .init()

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
            searchResult: searchResult.asDriver(),
            searchError: searchError.asDriver(onErrorJustReturn: .init(statusCode: 404, reason: "ExpectionError")),
            bookmarksResult: bookmarkList.asDriver())
    }

    private func checkKeyword(_ keyword: String?) -> Bool {
        if let keyword = keyword {
            return keyword.isEmpty
        }
        return true
    }
    
    private func getSearchResult(_ keyword: String) {
        Observable.zip(getMovieSearchResult(keyword), getMusicSearchResult(keyword))
            .map { (apiResult1, apiResult2) in
                var results: [MediaType: [MediaResultModel]] = [.Movie:[], .Music: []]
                results.updateValue(apiResult1, forKey: .Movie)
                results.updateValue(apiResult2, forKey: .Music)
                return results
            }
            .subscribe(onNext: { [weak self] (results) in
                self?.searchResult.accept(results)
            }, onError: { [weak self] (error) in
                if error is ErrorModel {
                    self?.searchError.accept(error as! ErrorModel)
                }
            })
            .disposed(by: disposeBag)
    }

    private func getMusicSearchResult(_ keyword: String) -> Observable<[MediaResultModel]> {
        Observable.create { (observer) in
            let musicUrl = String(format: Global.apiURL, arguments: [keyword, Key.MUSIC, Global.country.rawValue]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            APIModel.shared.getMusic(url: musicUrl) { (statusCode, result) in
                if statusCode == 200, let musicModel = result as? MusicModel {
                    observer.onNext(musicModel.results.map {$0.mediaResultModel})
                    observer.onCompleted()
                }
                if let errorModel = result as? ErrorModel {
                    observer.onError(errorModel)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    private func getMovieSearchResult(_ keyword: String) -> Observable<[MediaResultModel]> {
        Observable.create { (observer) in
            let movieUrl = String(format: Global.apiURL, arguments: [keyword, Key.MOVIE, Global.country.rawValue]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            APIModel.shared.getMovie(url: movieUrl) { (statusCode, result) in
                if statusCode == 200, let movieModel = result as? MovieModel {
                    observer.onNext(movieModel.results.map {$0.mediaResultModel})
                    observer.onCompleted()
                }
                if let errorModel = result as? ErrorModel {
                    observer.onError(errorModel)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
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
        let searchResult: Driver<[MediaType: [MediaResultModel]]>
        let searchError: Driver<ErrorModel>
        let bookmarksResult: Driver<[BookmarkModel]>
    }
}

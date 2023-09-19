import RxCocoa
import RxSwift

class SearchViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private var keyword = PublishSubject<String>()

    private(set) var searchResult = BehaviorRelay<Dictionary<String, Codable?>>(value: ["Movie": nil, "Music": nil])

    private(set) var bookmarkList: BehaviorRelay<[BookmarkModel]> = .init(value: [])

    private let disposeBag = DisposeBag()

    private let group = DispatchGroup()

    override init() {
        super.init()

        keyword
            .subscribe { [weak self] in
                self?.getSearchResult($0)
            }
            .disposed(by: disposeBag)
        
        input = .init(
            refresh: self.refresh.asObserver(),
            keyword: self.keyword.asObserver())

        output = .init(
            searchResult: self.searchResult.asDriver())
    }

    private func getSearchResult(_ keyword: String) {
        var tmpSearchResult: Dictionary<String, Codable?> = ["Movie": nil, "Music": nil]
        group.enter()
        DispatchQueue(label: "getMovieQueue", attributes: .concurrent).async {
            APIModel.shared.getMovie(keyword) { [weak self] statusCode, result in
                if statusCode == 200, result is MovieModel {
                    tmpSearchResult.updateValue(result, forKey: "Movie")
                }
                self?.group.leave()
            }
        }

        group.enter()
        DispatchQueue(label: "getMusicQueue", attributes: .concurrent).async {
            APIModel.shared.getMusic(keyword) { [weak self] statusCode, result in
                if statusCode == 200, result is MusicModel {
                    tmpSearchResult.updateValue(result, forKey: "Music")
                }
                self?.group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.searchResult.accept(tmpSearchResult)
        }
    }
}
extension SearchViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
        let keyword: AnyObserver<String>
    }

    struct Output {
        let searchResult: Driver<Dictionary<String, Codable?>>
    }
}

import RxCocoa
import RxSwift

class BookmarkViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private(set) var bookmarks: BehaviorRelay<Dictionary<String, [BookmarkModel]>> = BehaviorRelay(value: [Key.MOVIE: [], Key.MUSIC: []])

    override init() {
        super.init()
        refresh
            .subscribe(onNext: { [weak self] in
                self?.getBookmarks()
            })
            .disposed(by: disposeBag)

        input = .init(refresh: refresh.asObserver())
        output = .init(bookmarks: bookmarks.asDriver())
    }

    private func getBookmarks() {
        DBModel.shared.getBookmarks { [weak self] totalBookmarks in
            var tmpBookmarks: Dictionary<String, [BookmarkModel]> = [Key.MOVIE: [], Key.MUSIC: []]
            tmpBookmarks.updateValue(totalBookmarks.filter({ $0.mediaType == .Movie }), forKey: Key.MOVIE)

            tmpBookmarks.updateValue(totalBookmarks.filter({ $0.mediaType == .Music }), forKey: Key.MUSIC)

            self?.bookmarks.accept(tmpBookmarks)
        }
    }
}

extension BookmarkViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        let bookmarks: Driver<Dictionary<String, [BookmarkModel]>>
    }
}

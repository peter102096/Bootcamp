import RxCocoa
import RxSwift
import ShareModels

class BookmarkViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private(set) var movieBookmarks: BehaviorRelay<[BookmarkModel]> = BehaviorRelay(value: [])

    private(set) var musicBookmarks: BehaviorRelay<[BookmarkModel]> = BehaviorRelay(value: [])

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override init() {
        super.init()
        let getBookmarkSucceed = refresh.flatMapLatest { [unowned self] in
            getBookmarks()
        }

        input = .init(refresh: refresh.asObserver())

        output = .init(getBookmarkSucceed: getBookmarkSucceed.asDriver(onErrorJustReturn: false))
    }

    private func getBookmarks() -> Observable<Bool> {
        Observable.create { observer in
            DBModel.shared.getBookmarks { [weak self] totalBookmarks in
                self?.movieBookmarks.accept(totalBookmarks.filter({ $0.mediaType == .Movie }))
                self?.musicBookmarks.accept(totalBookmarks.filter({ $0.mediaType == .Music }))
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension BookmarkViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        let getBookmarkSucceed: Driver<Bool>
    }
}

import RxCocoa
import RxSwift
import ShareModels

enum AppearanceMode {
    case Dark
    case Light
}

class UserViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    private let refresh = PublishSubject<Void>()

    override init() {
        super.init()
        let bookmarks = refresh.flatMapLatest { [weak self] in
            self?.getBookmarks() ?? .empty()
        }.asDriver(onErrorJustReturn: [])

        input = .init(refresh: self.refresh.asObserver())
        output = .init(bookmarks: bookmarks)
    }

    private func getBookmarks() -> Observable<[BookmarkModel]> {
        Observable.create { observer in
            DBModel.shared.getBookmarks { bookmarks in
                observer.onNext(bookmarks)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
extension UserViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        let bookmarks: Driver<[BookmarkModel]>
    }
}

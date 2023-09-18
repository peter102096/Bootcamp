import RxCocoa
import RxSwift

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
        input = .init(refresh: self.refresh.asObserver())
    }

    private func getBookmarks() -> Driver<[BookmarkModel]> {
        Observable.create { observer in
            DBModel.shared.getBookmarks { bookmarks in
                observer.onNext(bookmarks)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: [])
    }
}
extension UserViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        let appearance: Driver<AppearanceMode>
        let bookmarks: Driver<[BookmarkModel]>
    }
}

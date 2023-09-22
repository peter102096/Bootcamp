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
    private let isDarkMode = PublishSubject<Bool>()

    override init() {
        super.init()

        let bookmarks = refresh.flatMapLatest { [unowned self] in
            getBookmarks()
        }

        let setThemeModeResult = isDarkMode.flatMapLatest { [unowned self] in
            setThemeMode($0)
        }

        input = .init(
            refresh: self.refresh.asObserver(),
            isDarkMode: isDarkMode.asObserver())
        output = .init(
            bookmarksCount: bookmarks.asDriver(onErrorJustReturn: 0),
            setThemeModeSucceed: setThemeModeResult.asDriver(onErrorJustReturn: false))
    }

    private func getBookmarks() -> Observable<Int> {
        Observable.create { observer in
            DBModel.shared.getBookmarks { bookmarks in
                observer.onNext(bookmarks.count)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    private func setThemeMode(_ isDarkMode: Bool) -> Observable<Bool> {
        Observable.create { (observer) in
            ShareDefaults.shared.setDarkMode(isDarkMode) { isSucceed in
                if isSucceed {
                    Global.isDarkMode = isDarkMode
                }
                observer.onNext(isSucceed)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
extension UserViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
        let isDarkMode: AnyObserver<Bool>
    }

    struct Output {
        let bookmarksCount: Driver<Int>
        let setThemeModeSucceed: Driver<Bool>
    }
}

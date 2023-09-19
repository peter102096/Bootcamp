import RxCocoa
import RxSwift

class BookmarkViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

}

extension BookmarkViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        
    }
}

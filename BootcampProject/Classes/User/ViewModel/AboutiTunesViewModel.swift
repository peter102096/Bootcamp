import RxCocoa
import RxSwift
import WebKit

class AboutiTunesViewModel: NSObject, ViewModelType {
    private(set) var input: Input!
    private(set) var output: Output!

    internal let aboutiTunesUrl = "https://support.apple.com/itunes"

    private let refresh = PublishSubject<Void>()

    internal let didFinishRelay = PublishRelay<Void?>()

    internal let didFailRelay = PublishRelay<String>()

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override init() {
        super.init()

        let urlRequest = refresh.flatMapLatest { [unowned self] in
            getURLRequest()
        }

        input = .init(refresh: refresh.asObserver())
        output = .init(
            urlRequest: urlRequest.asDriver(onErrorJustReturn: nil),
            didFinishLoad: didFinishRelay.asDriver(onErrorJustReturn: nil),
            didFailLoad: didFailRelay.asDriver(onErrorJustReturn: ""))
    }

    private func getURLRequest() -> Observable<URLRequest?> {
        Observable.create { [unowned self] observer in
            let request = URLRequest(url: URL(string: aboutiTunesUrl)!)
            observer.onNext(request)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension AboutiTunesViewModel {
    struct Input {
        let refresh: AnyObserver<Void>
    }

    struct Output {
        let urlRequest: Driver<URLRequest?>
        let didFinishLoad: Driver<Void?>
        let didFailLoad: Driver<String>
    }
}

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa

class AboutiTunesViewController: BaseViewController {

    lazy var webview: WKWebView = {
        WKWebView()
            .setNavigationDelegate(viewModel)
    }()

    private let viewModel = AboutiTunesViewModel()

    let disposeBag = DisposeBag()

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "AboutiTunes".localized()
    }

    override func setupUI() {
        view.addSubview(webview)
        webview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }

    override func bindView() {
        super.bindView()
        rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                self?.showLoadingView(in: self?.view, style: .Normal)
            })
            .disposed(by: disposeBag)
    }

    override func bindViewModel() {
        rx.viewDidAppear
            .mapToVoid()
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)

        viewModel.output.urlRequest
            .drive(onNext: { [weak self] (urlRequest) in
                if let urlRequest = urlRequest {
                    self?.webview.load(urlRequest)
                } else {
                    self?.dismissLoadingView()
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.didFinishLoad
            .drive(onNext: { [weak self] _ in
                self?.dismissLoadingView()
            })
            .disposed(by: disposeBag)

        viewModel.output.didFailLoad
            .drive(onNext: { [weak self] msg in
                self?.dismissLoadingView()
                self?.showExceptionErrorAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
}

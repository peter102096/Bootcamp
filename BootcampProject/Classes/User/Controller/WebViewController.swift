import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa

class WebViewController: BaseViewController {

    lazy var webview: WKWebView = {
        WKWebView()
    }()

    let disposeBag = DisposeBag()

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = URL(string: "https://support.apple.com/itunes") {
            let request = URLRequest(url: url)
            webview.load(request)
        }
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
        webview.rx.didStartLoad
            .subscribe { [weak self] nav in
                if let self = self {
                    self.showLoadingView(in: self.view, style: .Normal)
                }
            }
            .disposed(by: disposeBag)

        webview.rx.didFinishLoad
            .subscribe { [weak self] nav in
                self?.dismissLoadingView()
            }
            .disposed(by: disposeBag)
    }
}

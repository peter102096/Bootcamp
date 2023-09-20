import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa

class AboutiTunesViewController: BaseViewController {

    lazy var webview: WKWebView = {
        WKWebView()
            .setNavigationDelegate(self)
    }()

    private let aboutiTunesUrl = "https://support.apple.com/itunes"

    let disposeBag = DisposeBag()

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "AboutiTunes".localized()
        if let url = URL(string: aboutiTunesUrl) {
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

//    override func bindView() {
//        webview.rx.didStartLoad
//            .subscribe { [weak self] nav in
//                if let self = self {
//                    self.showLoadingView(in: self.view, style: .Normal)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        webview.rx.didFinishLoad
//            .subscribe { [weak self] nav in
//                self?.dismissLoadingView()
//            }
//            .disposed(by: disposeBag)
//    }
}

extension AboutiTunesViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            debugPrint(self.classForCoder, "urlStr: \(urlStr)")
            if urlStr == aboutiTunesUrl {
                debugPrint(self.classForCoder, "== aboutiTunesUrl")
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint(self.classForCoder, "didCommit")
        showLoadingView(in: self.view, style: .Normal)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint(self.classForCoder, "didFinish")
        dismissLoadingView()
    }
}

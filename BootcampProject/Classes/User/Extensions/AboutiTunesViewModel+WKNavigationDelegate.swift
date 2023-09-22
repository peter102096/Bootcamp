import WebKit

extension AboutiTunesViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishRelay.accept(())
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        didFailRelay.accept("DidFailLoad".localized())
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr == aboutiTunesUrl {
                decisionHandler(.allow)
                return
            }
        }
        didFailRelay.accept("NoAccess".localized())
        decisionHandler(.cancel)
    }
}

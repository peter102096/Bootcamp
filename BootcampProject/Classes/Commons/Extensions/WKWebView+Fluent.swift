import WebKit

extension WKWebView {
    @discardableResult
    public func setNavigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        self.navigationDelegate = delegate
        return self
    }
    @discardableResult
    public func setUiDelegate(_ delegate: WKUIDelegate?) -> Self {
        self.uiDelegate = delegate
        return self
    }
}

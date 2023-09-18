import UIKit

extension UISearchBar {
    @discardableResult
    public func setPlaceHolder(_ text: String?) -> Self {
        self.placeholder = text
        return self
    }
}

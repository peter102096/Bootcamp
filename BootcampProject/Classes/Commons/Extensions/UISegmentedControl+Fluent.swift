import UIKit

extension UISegmentedControl {
    @discardableResult
    public func insertSegment(_ title: String?) -> Self {
        insertSegment(withTitle: title, at: numberOfSegments, animated: false)
        return self
    }

    @discardableResult
    public func selectedSegmentIndex(_ index: Int) -> Self {
        self.selectedSegmentIndex = index
        return self
    }
}

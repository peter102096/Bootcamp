import Foundation
import UIKit

extension UIImage {
    @discardableResult
    public func setRenderingMode(_ mode: UIImage.RenderingMode) -> Self {
        self.withRenderingMode(mode)
        return self
    }
}

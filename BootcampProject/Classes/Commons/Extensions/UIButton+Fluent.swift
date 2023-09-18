import UIKit

extension UIButton {
    @discardableResult
    public func setTitle(_ title: String?) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    @discardableResult
    public func setFont(_ font: UIFont?) -> Self {
        self.titleLabel?.setFont(font)
        return self
    }

    @discardableResult
    public func setTitleColor(_ color: UIColor?) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }

    @discardableResult
    public func setTintColor(_ color: UIColor?) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    public func setImage(_ image: UIImage?) -> Self {
        setImage(image, for: .normal)
        return self
    }

    @discardableResult
    public func setContentMode(_ mode: UIView.ContentMode) -> Self {
        self.imageView?.contentMode = mode
        return self
    }

    @discardableResult
    public func setSemanticContent(_ mode: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = mode
        return self
    }
}

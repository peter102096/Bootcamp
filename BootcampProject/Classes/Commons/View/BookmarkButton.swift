import UIKit
import SnapKit

class BookmarkButton: UIButton {
    private var fillColor: UIColor? = Global.isDarkMode ? .orange : .purple
    private var notFillColor: UIColor? = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
    var isLiked: Bool = false {
        didSet {
            tintColor = isLiked ? fillColor : notFillColor
            setImage(isLiked ? .init(systemName: "star.fill") : .init(systemName: "star"), for: .normal)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tintColor = notFillColor
    }

    func updateAppearance() {
        fillColor = Global.isDarkMode ? .orange : .purple
        notFillColor = Global.isDarkMode ?
            .darkModeTxtColor : .lightModeTxtColor
        tintColor = isLiked ? fillColor : notFillColor
    }

}

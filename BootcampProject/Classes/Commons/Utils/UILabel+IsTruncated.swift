import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text, let font = font else {
            return false
        }
        let labelSize: CGSize = .init(width: frame.size.width, height: .greatestFiniteMagnitude)

        let textSize = labelText.boundingRect(with: labelSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)

        let numberOfLines = Int(ceil(textSize.height / font.lineHeight))

        return numberOfLines > 2
    }
}

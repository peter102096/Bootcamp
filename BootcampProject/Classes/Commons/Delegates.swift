import UIKit

@objc protocol MediaTableViewCellDelegate: AnyObject {
    @objc func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel)

    @objc optional func didTapExpendedBtn(_ cell: UITableViewCell, indexPath: IndexPath)
}

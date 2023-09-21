import UIKit
import ShareModels

@objc protocol MediaTableViewCellDelegate: AnyObject {
    @objc func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel)
}

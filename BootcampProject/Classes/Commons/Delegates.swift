import UIKit
import ShareModels

@objc protocol MediaTableViewCellDelegate: AnyObject {
    @objc optional func didDeselectedBookmark(_ cell: UITableViewCell, model: BookmarkModel)
    @objc optional func didRefreshBookmark(_ cell: UITableViewCell)
}

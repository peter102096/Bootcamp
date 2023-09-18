import UIKit

extension BookmarkViewController: MediaTableViewCellDelegate {
    func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        getBookmarks()
    }
}

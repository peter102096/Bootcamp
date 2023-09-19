import UIKit

extension SearchViewController: MediaTableViewCellDelegate {
    func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        getBookmarks()
    }
}

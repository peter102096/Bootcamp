import UIKit

extension SearchViewController: MediaTableViewCellDelegate {
    func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        getBookmarks()
    }

    func didTapExpendedBtn(_ cell: UITableViewCell, indexPath: IndexPath) {
        searchResultTableView.reloadRows(at: [indexPath], with: .bottom)
        searchResultTableView.beginUpdates()
        searchResultTableView.endUpdates()
    }
}

import UIKit
import ShareModels

extension BookmarkViewController: MediaTableViewCellDelegate {
    func didDeselectedBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        viewModel.input.refresh.onNext(())
    }
}

import UIKit
import ShareModels

extension BookmarkViewController: MediaTableViewCellDelegate {
    func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        viewModel.input.refresh.onNext(())
    }
}

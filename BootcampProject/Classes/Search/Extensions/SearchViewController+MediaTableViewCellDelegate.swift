import UIKit
import ShareModels

extension SearchViewController: MediaTableViewCellDelegate {
    func didDeselectBookmark(_ cell: UITableViewCell, model: BookmarkModel) {
        viewModel.input.refresh.onNext(())
    }
}

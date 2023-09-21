import UIKit
import ShareModels

extension SearchViewController: MediaTableViewCellDelegate {
    func didRefreshBookmark(_ cell: UITableViewCell) {
        viewModel.input.refresh.onNext(())
    }
}

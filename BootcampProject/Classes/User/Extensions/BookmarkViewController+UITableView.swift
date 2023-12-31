import UIKit

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            if let url = URL(string: viewModel.movieBookmarks.value[indexPath.row].trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        case 1:
            if let url = URL(string: viewModel.musicBookmarks.value[indexPath.row].trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            return viewModel.movieBookmarks.value.count
        case 1:
            return viewModel.musicBookmarks.value.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Key.MOVIE_CELL, for: indexPath) as? MovieTableViewCell {
                cell.delegate = self
                cell.setUp(viewModel.movieBookmarks.value[indexPath.row])
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Key.MUSIC_CELL, for: indexPath) as? MusicTableViewCell {
                cell.delegate = self
                cell.setUp(viewModel.musicBookmarks.value[indexPath.row])
                return cell
            }
            break
        default:
            break
        }
        return .init()
    }
}

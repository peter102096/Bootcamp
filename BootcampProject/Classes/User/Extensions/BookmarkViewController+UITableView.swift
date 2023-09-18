import UIKit

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            if let url = URL(string: moveieBookmarksList[indexPath.row].trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        case 1:
            if let url = URL(string: musicBookmarksList[indexPath.row].trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        default:
            break
        }
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            return moveieBookmarksList.count
        case 1:
            return musicBookmarksList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mediaTypeSegmentControl.selectedSegmentIndex {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell {
                cell.delegates = self
                cell.setUp(moveieBookmarksList[indexPath.row], indexPath: indexPath)
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as? MusicTableViewCell {
                cell.delegate = self
                cell.setUp(musicBookmarksList[indexPath.row])
                return cell
            }
            break
        default:
            break
        }
        return .init()
    }
}
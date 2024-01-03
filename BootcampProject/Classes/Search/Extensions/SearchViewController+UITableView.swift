import UIKit

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let trackViewURL = viewModel.searchResult.value[.Movie]?[indexPath.row].trackViewURL, let url = URL(string: trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        case 1:
            if let trackViewURL = viewModel.searchResult.value[.Music]?[indexPath.row].trackViewURL, let url = URL(string: trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
            headerView.textLabel?.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.searchResult.value[.Movie]?.count ?? 0
        case 1:
            return viewModel.searchResult.value[.Music]?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Movie".localized()
        case 1:
            return "Music".localized()
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Key.MOVIE_CELL, for: indexPath) as? MovieTableViewCell, let movieResult = viewModel.searchResult.value[.Movie]?[indexPath.row] {
                cell.delegate = self
                cell.setUp(movieResult, isLiked: viewModel.bookmarkList.value.first(where: { $0.trackId == String(movieResult.trackID) })?.isLiked ?? false)
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Key.MUSIC_CELL, for: indexPath) as? MusicTableViewCell, let musicResult = viewModel.searchResult.value[.Music]?[indexPath.row] {
                cell.delegate = self
                cell.setUp(musicResult, isLiked: viewModel.bookmarkList.value.first(where: { $0.trackId == String(musicResult.trackID) })?.isLiked ?? false)
                return cell
            }
            break
        default:
            break
        }
        return .init()
    }
    
    
}

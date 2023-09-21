import UIKit

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let movieResult = viewModel.movieSearchResult.value?.results[indexPath.row], let url = URL(string: movieResult.trackViewURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            break
        case 1:
            if let musicResult = viewModel.musicSearchResult.value?.results[indexPath.row], let url = URL(string: musicResult.trackViewURL), UIApplication.shared.canOpenURL(url) {
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
            return viewModel.movieSearchResult.value?.results.count ?? 0
        case 1:
            return viewModel.musicSearchResult.value?.results.count ?? 0
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: Key.MOVIE_CELL, for: indexPath) as? MovieTableViewCell {
                if let movieResult = viewModel.movieSearchResult.value?.results[indexPath.row] {
                    cell.setUp(movieResult, isLiked: viewModel.bookmarkList.value.first(where: { $0.trackId == String(movieResult.trackID) })?.isLiked ?? false)
                }
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as? MusicTableViewCell {
                if let musicResult = viewModel.musicSearchResult.value?.results[indexPath.row] {
                    cell.setUp(musicResult, isLiked: viewModel.bookmarkList.value.first(where: { $0.trackId == String(musicResult.trackID) })?.isLiked ?? false)
                }
                return cell
            }
            break
        default:
            break
        }
        return .init()
    }
    
    
}

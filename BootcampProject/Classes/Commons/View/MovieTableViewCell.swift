import UIKit
import RxSwift
import RxCocoa

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var thunbnilImgView: UIImageView!

    @IBOutlet weak var trackNameLabel: UILabel!

    @IBOutlet weak var artistNameLabel: UILabel!

    @IBOutlet weak var trackCensoredNameLabel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var longDscriptionLabel: UILabel!

    @IBOutlet weak var readMoreBtn: UIButton!

    @IBOutlet weak var bookmarkBtn: BookmarkButton!

    private var bookmarkBtnDisposable: Disposable? = nil

    private var readMoreBtnDisposable: Disposable? = nil

    weak var delegates: MediaTableViewCellDelegate?

    private var isExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    func setUp(_ model: MovieResultModel, isLiked: Bool) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        trackCensoredNameLabel.text = model.collectionName
        durationLabel.text = model.trackTimeMillis == nil ? "NA:NA:NA" : model.trackTimeMillis?.movieFormat
        longDscriptionLabel.text = model.longDescription
        bookmarkBtn.isLiked = isLiked
        longDscriptionLabel.isTruncated ? readMoreBtn.setHiddenState(false) : readMoreBtn.setHiddenState(true)
        
        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()

                    self.bookmarkBtn.isLiked ? self.setBookmark(model) : DBModel.shared.removeBookmark(String(model.trackID))
                }
            }
    }

    func setUp(_ model: BookmarkModel) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        trackCensoredNameLabel.text = model.collectionName
        durationLabel.text = model.trackTimeMillis == 0 ? "NA:NA:NA" : model.trackTimeMillis.movieFormat
        longDscriptionLabel.text = model.longDescription
        bookmarkBtn.isLiked = model.isLiked
        longDscriptionLabel.isTruncated ? readMoreBtn.setHiddenState(false) : readMoreBtn.setHiddenState(true)
        
        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()
                    DBModel.shared.removeBookmark(model.trackId)
                    self.delegates?.didDeselectBookmark(self, model: model)
                }
            }
    }

    private func setBookmark(_ model: MovieResultModel) {
        DBModel.shared.setBookmark(model.bookmarkModel)
    }

    private func updateAppearance() {
        contentView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        bookmarkBtn.updateAppearance()
        trackNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        artistNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        trackCensoredNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        durationLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        longDscriptionLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
    }

    private func resetViewState() {
        bookmarkBtnDisposable?.dispose()
        readMoreBtnDisposable?.dispose()
        updateAppearance()
        readMoreBtnDisposable = readMoreBtn.rx.tap
            .subscribe(onNext: {  [weak self] _ in
                if let self = self, let tableView = self.superview as? UITableView {
                    self.isExpanded.toggle()
                    self.longDscriptionLabel.numberOfLines = self.isExpanded ? 0 : 2
                    self.readMoreBtn.setTitle(self.isExpanded ? "read less" : "...read more")
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            })
    }
}

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import ShareModels

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var thunbnilImgView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var bookmarkBtn: BookmarkButton!

    private var bookmarkBtnDisposable: Disposable? = nil

    weak var delegate: MediaTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setUp(_ model: MusicResultModel, isLiked: Bool) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        collectionNameLabel.text = model.collectionName
        durationLabel.text = model.trackTimeMillis == nil ? "NA:NA" : model.trackTimeMillis?.musicFormat
        bookmarkBtn.isLiked = isLiked

        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()

                    self.bookmarkBtn.isLiked ? self.setBookmark(model) : DBModel.shared.removeBookmark(String(model.trackID))

                    self.delegate?.didRefreshBookmark?(self)
                }
            }
    }

    func setUp(_ model: BookmarkModel) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        collectionNameLabel.text = model.collectionName
        durationLabel.text = model.trackTimeMillis == 0 ? "NA:NA" : model.trackTimeMillis.musicFormat
        bookmarkBtn.isLiked = model.isLiked

        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()
                    DBModel.shared.removeBookmark(model.trackId)
                    self.delegate?.didDeselectedBookmark?(self, model: model)
                }
            }
    }

    func setBookmark(_ model: MusicResultModel) {
        DBModel.shared.setBookmark(model.bookmarkModel)
    }

    private func updateAppearance() {
        contentView.backgroundColor = Global.isDarkMode ? .darkModeBgColor : .lightModeBgColor
        bookmarkBtn.updateAppearance()
        trackNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        artistNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        collectionNameLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
        durationLabel.textColor = Global.isDarkMode ? .darkModeTxtColor : .lightModeTxtColor
    }

    private func resetViewState() {
        bookmarkBtnDisposable?.dispose()
        updateAppearance()
    }
}

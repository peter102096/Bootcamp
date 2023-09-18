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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    func setUp(_ model: MovieResultModel, isLiked: Bool, indexPath: IndexPath) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        trackCensoredNameLabel.text = model.trackCensoredName
        durationLabel.text = model.trackTimeMillis == nil ? "NA:NA:NA" : model.trackTimeMillis?.movieFormat
        longDscriptionLabel.text = model.longDescription
        bookmarkBtn.isLiked = isLiked
        
        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()

                    self.bookmarkBtn.isLiked ? setBookmark(model) : DBModel.shared.removeBookmark(String(model.trackID))
                }
            }

        readMoreBtnDisposable = readMoreBtn.rx.tap
            .subscribe(onNext: {  [weak self] _ in
                if let self = self {
                    self.longDscriptionLabel.numberOfLines = 0
                    self.delegates?.didTapExpendedBtn?(self, indexPath: indexPath)
                }
            })
    }

    func setUp(_ model: BookmarkModel, indexPath: IndexPath) {
        resetViewState()
        thunbnilImgView.sd_setImage(with: URL(string: model.thumbnailURL), placeholderImage: .photoIcon, options: [.refreshCached, .allowInvalidSSLCertificates])
        trackNameLabel.text = model.trackName
        artistNameLabel.text = model.artistName
        trackCensoredNameLabel.text = model.collectionName
        durationLabel.text = model.trackTimeMillis == 0 ? "NA:NA:NA" : model.trackTimeMillis.movieFormat
        longDscriptionLabel.text = model.longDescription
        bookmarkBtn.isLiked = model.isLiked
        
        bookmarkBtnDisposable = bookmarkBtn.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    self.bookmarkBtn.isLiked.toggle()
                    DBModel.shared.removeBookmark(model.trackId)
                    self.delegates?.didDeselectBookmark(self, model: model)
                }
            }

        readMoreBtnDisposable = readMoreBtn.rx.tap
            .subscribe(onNext: {  [weak self] _ in
                if let self = self {
                    self.longDscriptionLabel.numberOfLines = 0
                    self.delegates?.didTapExpendedBtn?(self, indexPath: indexPath)
                }
            })
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
    }
}
import JGProgressHUD
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CustomLoadingView: JGProgressHUD {
    private let cancelBtnClickedRelay = PublishRelay<Void>()

    private var cancelBtn: UIButton = {
        UIButton(type: .system)
            .setTitle("Cancel")
            .setTitleColor(.red)
    }()

    private let disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(style: Global.isDarkMode ? .dark : .light)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).inset(6)
            $0.centerX.equalTo(contentView)
        }

        cancelBtn.rx.tap
            .bind(to: cancelBtnClickedRelay)
            .disposed(by: disposeBag)
    }

    func updateStyle(_ style: JGProgressHUDStyle) {
        self.style = style
    }

    var cancelBtnClicked: Observable<Void> {
        return cancelBtnClickedRelay.asObservable()
    }
}

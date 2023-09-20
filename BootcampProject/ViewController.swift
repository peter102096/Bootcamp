import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    lazy var loadingView: CustomLoadingView = {
        CustomLoadingView()
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.cancelBtnClicked
            .subscribe (onNext: { _ in
                debugPrint(self.classForCoder, "cancel")
                self.loadingView.dismiss()
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingView.show(in: self.view)
        }
    }
}

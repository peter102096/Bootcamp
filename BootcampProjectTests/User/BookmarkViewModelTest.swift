import Quick
import Nimble
import RxTest
import ShareModels

@testable import RxSwift
@testable import RxCocoa
@testable import AFNetworking
@testable import RealmSwift

class BookmarkViewModelTest: QuickSpec {
    override func spec() {
        describe("SearchViewModel") {
            var viewModel: UserViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = UserViewModel()
                scheduler = .init(initialClock: 0)
                disposeBag = .init()
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
            }

            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }

            
        }
    }
}

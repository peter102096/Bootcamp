import Quick
import Nimble
import RxTest

@testable import RxSwift
@testable import RxCocoa
@testable import AFNetworking
@testable import RealmSwift

class SearchViewModelTest: QuickSpec {
    override func spec() {
        describe("SearchViewModel") {
            var viewModel: SearchViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = SearchViewModel()
                scheduler = .init(initialClock: 0)
                disposeBag = .init()
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                Realm.Configuration(fileURL: URL(fileURLWithPath: "..."))
            }

            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }

            context("When initial") {
                it("searchResult should have get nil value") {

                    let searchResult = scheduler.createObserver(Dictionary<String, Codable?>.self)

                    viewModel.output.searchResult
                        .drive(searchResult)
                        .disposed(by: disposeBag)

                    expect(searchResult.events.first?.value.element?[Key.MOVIE]).to(beNil())
                    expect(searchResult.events.first?.value.element?[Key.MUSIC]).to(beNil())
                    
                }

                it("bookmarksResult should have get nil value") {
                    let bookmarksResult = scheduler.createObserver([BookmarkModel].self)

                    viewModel.output.bookmarksResult
                        .drive(bookmarksResult)
                        .disposed(by: disposeBag)

                    expect(bookmarksResult.events.first?.value.element).to(beNil())
                }
            }

            context("when refresh") {
                it("should be get bookmarks array") {
                    let bookmarksResult = scheduler.createObserver([BookmarkModel].self)

                    viewModel.output.bookmarksResult
                        .drive(bookmarksResult)
                        .disposed(by: disposeBag)

                    scheduler.createColdObservable([.next(10, ())])
                        .bind(to: viewModel.input.refresh)
                        .disposed(by: disposeBag)

                    scheduler.start()

                    expect(bookmarksResult.events.first?.value.element?.count).to(equal(0))
                }
            }
        }
        
    }
}

import Quick
import Nimble
import RxTest
import ShareModels

@testable import RxSwift
@testable import RxCocoa
@testable import AFNetworking
@testable import RealmSwift

class UserViewModelTest: QuickSpec {
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

            // MARK: - viewmodel initial
            context("When view model initial") {
                it("bookmarksCount should have get nil value") {
                    let bookmarksCount = scheduler.createObserver(Int.self)

                    viewModel.output.bookmarksCount
                        .drive(bookmarksCount)
                        .disposed(by: disposeBag)

                    expect(bookmarksCount.events.first?.value.element).to(beNil())
                }

                it("setThemeModeSucceed should have get nil value") {
                    let setThemeModeSucceed = scheduler.createObserver(Bool.self)

                    viewModel.output.setThemeModeSucceed
                        .drive(setThemeModeSucceed)
                        .disposed(by: disposeBag)

                    expect(setThemeModeSucceed.events.first?.value.element).to(beNil())
                }
            }

            // MARK: - refresh
            context("when view will appear that will call input with refresh") {
                it("when app not have bookmark record that should be get count is 0") {
                    let bookmarksCount = scheduler.createObserver(Int.self)

                    viewModel.output.bookmarksCount
                        .drive(bookmarksCount)
                        .disposed(by: disposeBag)

                    viewModel.input.refresh.onNext(())

                    let getBookmarksExpectation = self.expectation(description: "getBookmarks record")

                    viewModel.output.bookmarksCount
                        .asObservable()
                        .take(3)
                        .subscribe {
                            if $0.element == 0 {
                                getBookmarksExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 5) { _ in
                        expect(bookmarksCount.events.last?.value.element).to(equal(0))
                    }
                }

                it("when app have 1 bookmark record that should be get count is equal 1") {

                    DBModel.shared.setBookmark(
                        .init(trackId: "854658129",
                              type: .Movie,
                              artistName: "Steve Rash",
                              collectionName: "",
                              trackName: "魅力四射3 Bring It On: All or Nothing",
                              trackViewURL: "https://itunes.apple.com/tw/movie/%E9%AD%85%E5%8A%9B%E5%9B%9B%E5%B0%843-bring-it-on-all-or-nothing/id854658129?uo=4",
                              thumbnailURL: "https://is1-ssl.mzstatic.com/image/thumb/Video3/v4/38/47/76/38477692-5552-a818-3285-6911979a5d31/88572_MLPA_BringItOnAllOrNothing_1400x2100.jpg/100x100bb.jpg",
                              releaseDate: "2006-08-08T07:00:00Z",
                              trackTimeMillis: 5930055,
                              longDescription: "在這齣全新喜劇中，準備收看更有趣、更有風格、更刺激的內容吧！在學校很紅的布蘭妮艾倫（海蒂．潘妮迪亞飾）從時髦的太平洋海景高中搬到工人階級的克蘭蕭高中，她的生活一下子從啦啦隊隊長變成了啦啦隊災難。布蘭妮發現自己跟班上同學格格不入，尤其跟啦啦隊長卡蜜莉（索蘭芝．諾利斯飾）處不好。當她贏得啦啦隊員的地位，卻得在一場跨鎮啦啦隊比賽中，與自己曾待過的啦啦隊較量。這場比賽的贏家能在當紅歌手蕾哈娜的新影片中登場，只有一支隊伍能夠獲勝，爭得啦啦隊史上的一席之地。",
                              isLiked: true))

                    let bookmarksCount = scheduler.createObserver(Int.self)

                    viewModel.output.bookmarksCount
                        .drive(bookmarksCount)
                        .disposed(by: disposeBag)

                    viewModel.input.refresh.onNext(())

                    let getBookmarksExpectation = self.expectation(description: "getBookmarks record")

                    viewModel.output.bookmarksCount
                        .asObservable()
                        .take(3)
                        .subscribe {
                            if $0.element != 0 {
                                getBookmarksExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 4) { _ in
                        expect(bookmarksCount.events.last?.value.element).to(equal(1))
                        DBModel.shared.resetDB()
                    }
                }
            }

            // MARK: - select theme mode
            context("when select theme mode with action sheet") {
                it("set dark mode should be get setSucceed that must be true") {
                    let setThemeModeSucceed = scheduler.createObserver(Bool.self)

                    viewModel.output.setThemeModeSucceed
                        .drive(setThemeModeSucceed)
                        .disposed(by: disposeBag)

                    viewModel.input.isDarkMode.onNext(true)

                    let setThemeModeExpectation = self.expectation(description: "setThemeMode")

                    viewModel.output.setThemeModeSucceed
                        .asObservable()
                        .take(3)
                        .subscribe {
                            if $0.element == true {
                                setThemeModeExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 4) { _ in
                        expect(setThemeModeSucceed.events.first?.value.element).to(beTrue())
                    }
                }

                it("set light mode should be get setSucceed that must be true") {
                    let setThemeModeSucceed = scheduler.createObserver(Bool.self)

                    viewModel.output.setThemeModeSucceed
                        .drive(setThemeModeSucceed)
                        .disposed(by: disposeBag)

                    viewModel.input.isDarkMode.onNext(false)

                    let setThemeModeExpectation = self.expectation(description: "setThemeMode")

                    viewModel.output.setThemeModeSucceed
                        .asObservable()
                        .take(3)
                        .subscribe {
                            if $0.element == true {
                                setThemeModeExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 4) { _ in
                        expect(setThemeModeSucceed.events.first?.value.element).to(beTrue())
                    }
                }
            }
        }
    }
}

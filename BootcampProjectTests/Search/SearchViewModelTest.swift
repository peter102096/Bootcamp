import Quick
import Nimble
import RxTest
import ShareModels

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
            }

            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }

            // MARK: - viewmodel initial
            context("When view model initial") {

                it("keywordIsEmpty should have get nil") {
                    let keywordIsEmpty = scheduler.createObserver(Bool.self)

                    viewModel.output.keywordIsEmpty
                        .drive(keywordIsEmpty)
                        .disposed(by: disposeBag)

                    expect(keywordIsEmpty.events.first?.value.element).to(beNil())
                }

                it("movie and music searchResult should have get array size 0") {

                    let movieSearchResult = scheduler.createObserver([MovieResultModel].self)
                    let musicSearchResult = scheduler.createObserver([MusicResultModel].self)

                    viewModel.output.movieSearchResult
                        .drive(movieSearchResult)
                        .disposed(by: disposeBag)

                    viewModel.output.musicSearchResult
                        .drive(musicSearchResult)
                        .disposed(by: disposeBag)

                    expect(movieSearchResult.events.first?.value.element?.count).to(equal(0))
                    expect(musicSearchResult.events.first?.value.element?.count).to(equal(0))
                }

                it("bookmarksResult should have get array size 0") {
                    let bookmarksResult = scheduler.createObserver([BookmarkModel].self)

                    viewModel.output.bookmarksResult
                        .drive(bookmarksResult)
                        .disposed(by: disposeBag)

                    expect(bookmarksResult.events.first?.value.element?.count).to(equal(0))
                }
            }
            // MARK: - refresh
            context("when view will appear that will call input with refresh") {

                it("if db has not bookmark record that should be get bookmarks array count is 0") {

                    let bookmarksResult = scheduler.createObserver([BookmarkModel].self)

                    viewModel.output.bookmarksResult
                        .drive(bookmarksResult)
                        .disposed(by: disposeBag)

                    viewModel.input.refresh.onNext(())

                    let expectation = self.expectation(description: "getDB")
                    viewModel.output.bookmarksResult
                        .asObservable()
                        .take(2)
                        .subscribe {
                            if $0.count == 0 {
                                expectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 3) {
                        _ in
                        expect(bookmarksResult.events.last?.value.element?.count).to(equal(0))
                    }
                }

                it("if db set 1 bookmark record that should be get bookmarks array count is 1") {
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
                    
                    let bookmarksResult = scheduler.createObserver([BookmarkModel].self)

                    viewModel.output.bookmarksResult
                        .drive(bookmarksResult)
                        .disposed(by: disposeBag)

                    viewModel.input.refresh.onNext(())

                    let expectation = self.expectation(description: "getDB")
                    viewModel.output.bookmarksResult
                        .asObservable()
                        .take(2)
                        .subscribe {
                            if $0.count != 0 {
                                expectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 3) {
                        _ in
                        expect(bookmarksResult.events.last?.value.element?.count).to(equal(1))
                        DBModel.shared.resetDB()
                    }
                }
            }

            //MARK: - enter keyword
            context("when enter keyword") {
                it("if keyword is empty should be get keywordIsEmpty is true") {
                    let keywordIsEmpty = scheduler.createObserver(Bool.self)
                    viewModel.output.keywordIsEmpty
                        .drive(keywordIsEmpty)
                        .disposed(by: disposeBag)

                    viewModel.input.keyword.onNext("")

                    expect(keywordIsEmpty.events.last?.value.element).to(beTrue())
                }

                it("if keyword is nil should be get keywordIsEmpty is true") {
                    let keywordIsEmpty = scheduler.createObserver(Bool.self)
                    viewModel.output.keywordIsEmpty
                        .drive(keywordIsEmpty)
                        .disposed(by: disposeBag)

                    viewModel.input.keyword.onNext(nil)

                    expect(keywordIsEmpty.events.last?.value.element).to(beTrue())
                }
                // MARK: APITest
                it("if keyword not empty should be get search result") {
                    let keywordIsEmpty = scheduler.createObserver(Bool.self)
                    let movieSearchResult = scheduler.createObserver([MovieResultModel].self)
                    let musicSearchResult = scheduler.createObserver([MusicResultModel].self)

                    viewModel.output.keywordIsEmpty
                        .drive(keywordIsEmpty)
                        .disposed(by: disposeBag)


                    viewModel.output.movieSearchResult
                        .drive(movieSearchResult)
                        .disposed(by: disposeBag)

                    viewModel.output.musicSearchResult
                        .drive(musicSearchResult)
                        .disposed(by: disposeBag)

                    viewModel.input.keyword.onNext("Nothing")

                    let movieExpectation = self.expectation(description: "getMovieAPI")
                    viewModel.output.movieSearchResult
                        .asObservable()
                        .take(10)
                        .subscribe {
                            if $0.element?.count != 0 {
                                movieExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 11) {
                        _ in
                        expect(movieSearchResult.events.last?.value.element?.count).notTo(equal(0))
                        expect(keywordIsEmpty.events.first?.value.element).to(beFalse())
                    }

                    viewModel.input.keyword.onNext("Nothing")
                    let musicExpectation = self.expectation(description: "getMusicAPI")
                    viewModel.output.musicSearchResult
                        .asObservable()
                        .take(10)
                        .subscribe {
                            if $0.element?.count != 0 {
                                musicExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)

                    self.waitForExpectations(timeout: 11) {
                        _ in
                        expect(musicSearchResult.events.last?.value.element?.count).notTo(equal(0))
                        expect(keywordIsEmpty.events.last?.value.element).to(beFalse())
                    }
                }
            }

            // MARK: - APITest cancel request
            context("when cancel request") {
                it("should be cancel all request") {
                    let musicSearchResult = scheduler.createObserver([MusicResultModel].self)
                    
                    viewModel.output.musicSearchResult
                        .drive(musicSearchResult)
                        .disposed(by: disposeBag)

                    scheduler.createColdObservable([.next(10, "hello")])
                        .bind(to: viewModel.input.keyword)
                        .disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(15, ())])
                        .bind(to: viewModel.input.cancelRequest)
                        .disposed(by: disposeBag)

                    scheduler.start()
                    
                    let musicExpectation = self.expectation(description: "getMusicAPI")
                    viewModel.output.musicSearchResult
                        .asObservable()
                        .take(10)
                        .subscribe {
                            dump($0.element)
                            if $0.element?.count == 0 {
                                musicExpectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)
                    
                    self.waitForExpectations(timeout: 11) {
                        _ in
                        expect(musicSearchResult.events.last?.value.element?.count).to(equal(0))
                    }
                }
            }
        }
    }
}

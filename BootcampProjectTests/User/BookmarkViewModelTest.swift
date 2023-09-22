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
            var viewModel: BookmarkViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = BookmarkViewModel()
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
                it("getBookmarkSucceed should be get nil") {
                    let getBookmarkSucceed = scheduler.createObserver(Bool.self)
                    viewModel.output.getBookmarkSucceed
                        .drive(getBookmarkSucceed)
                        .disposed(by: disposeBag)
                    expect(getBookmarkSucceed.events.first?.value.element).to(beNil())
                }
            }

            // MARK: - refresh
            context("when view will appear that will call input with refresh") {
                it("getBookmarkSucceed should be get true") {

                    setBookmark()

                    let getBookmarkSucceed = scheduler.createObserver(Bool.self)
                    viewModel.output.getBookmarkSucceed
                        .drive(getBookmarkSucceed)
                        .disposed(by: disposeBag)

                    let expectation = self.expectation(description: "getBookmark")

                    viewModel.input.refresh.onNext(())

                    viewModel.output.getBookmarkSucceed
                        .asObservable()
                        .take(3)
                        .subscribe { isSucceed in
                            if isSucceed {
                                expectation.fulfill()
                                return
                            }
                        }
                        .disposed(by: disposeBag)
                    self.waitForExpectations(timeout: 4) { _ in 
                        expect(getBookmarkSucceed.events.last?.value.element).to(beTrue())
                    }
                }
            }

            func setBookmark() {
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

                DBModel.shared.setBookmark(
                    .init(trackId: "368016726",
                          type: .Music,
                          artistName: "B.o.B",
                          collectionName: "B.o.B Presents: The Adventures of Bobby Ray (Deluxe)",
                          trackName: "Nothin' On You (feat. Bruno Mars)",
                          trackViewURL: "https://music.apple.com/us/album/nothin-on-you-feat-bruno-mars/368016701?i=368016726&uo=4",
                          thumbnailURL: "https://is1-ssl.mzstatic.com/image/thumb/Music/14/0b/8e/mzi.vsvfenht.jpg/100x100bb.jpg",
                          releaseDate: "2009-12-15T08:00:00Z",
                          trackTimeMillis: 268320,
                          longDescription: "",
                          isLiked: true))
            }
        }
    }
}

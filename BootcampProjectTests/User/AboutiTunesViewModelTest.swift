import Quick
import Nimble
import RxTest
import ShareModels

@testable import RxSwift
@testable import RxCocoa
@testable import AFNetworking
@testable import RealmSwift

class AboutiTunesViewModelTest: QuickSpec {
    override func spec() {
        describe("SearchViewModel") {
            var viewModel: AboutiTunesViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                viewModel = AboutiTunesViewModel()
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
                it("urlRequest should be nil") { 
                    let urlRequest = scheduler.createObserver(URLRequest?.self)
                    viewModel.output.urlRequest
                        .drive(urlRequest)
                        .disposed(by: disposeBag)
                    expect(urlRequest.events.first?.value.element).to(beNil())
                }

                it("didFinishLoad and didFailLoad should be nil") {
                    let didFinishLoad = scheduler.createObserver(Void?.self)
                    viewModel.output.didFinishLoad
                        .drive(didFinishLoad)
                        .disposed(by: disposeBag)

                    let didFailLoad = scheduler.createObserver(String.self)
                    viewModel.output.didFailLoad
                        .drive(didFailLoad)
                        .disposed(by: disposeBag)

                    expect(didFinishLoad.events.first?.value.element).to(beNil())
                    expect(didFailLoad.events.first?.value.element).to(beNil())
                }
            }

            context("when view will appear that will call input with refresh") {
                it("urlRequest should be not nil") {
                    let urlRequest = scheduler.createObserver(URLRequest?.self)
                    viewModel.output.urlRequest
                        .drive(urlRequest)
                        .disposed(by: disposeBag)

                    viewModel.input.refresh.onNext(())

                    expect(urlRequest.events.first?.value.element).notTo(beNil())
                }
            }

            context("when load web view ") {
                it("if load finish should be not nil") {
                    let didFinishLoad = scheduler.createObserver(Void?.self)
                    viewModel.output.didFinishLoad
                        .drive(didFinishLoad)
                        .disposed(by: disposeBag)

                    viewModel.didFinishRelay.accept(())

                    expect(didFinishLoad.events.first?.value.element).notTo(beNil())
                }

                it("if load fail should be get error string") {
                    let didFailLoad = scheduler.createObserver(String.self)
                    viewModel.output.didFailLoad
                        .drive(didFailLoad)
                        .disposed(by: disposeBag)

                    viewModel.didFailRelay.accept("test error")

                    expect(didFailLoad.events.first?.value.element).to(equal("test error"))
                }
            }
        }
    }
}

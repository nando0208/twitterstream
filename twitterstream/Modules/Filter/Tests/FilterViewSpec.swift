//
//  FilterViewSpec.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 23/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Nimble_Snapshots

@testable import twitterstream

/*//swiftlint:disable function_body_length*/
//swiftlint:disable line_length
class FilterViewSpec: QuickSpec {
    override func spec() {

        describe("FilterView") {
            context("Show empty view") {
                let flexibleSizeContainers = createFlexibleSizeContainers(tweets: [], hasError: false)

                flexibleSizeContainers.forEach { container in
                    beforeEach {
                        // Access the view to trigger the viewDidLoad().
                        _ = container.parent.view
                        _ = container.child.view
                    }

                    it("should have correct empty view \(container.device.hashValue)") {
                        expect(container.parent).to(haveValidSnapshot(named: "filterView_emptyState_device_\(container.device.hashValue)"))
                    }
                }
            }

            context("Show tweets") {
                let flexibleSizeContainers = createFlexibleSizeContainers(tweets: UnitTestUtils.genereteTweet(5), hasError: false)

                flexibleSizeContainers.forEach { container in
                    beforeEach {
                        // Access the view to trigger the viewDidLoad().
                        _ = container.parent.view
                        _ = container.child.view
                    }

                    it("should show tweets \(container.device.hashValue)") {
                        expect(container.parent).to(haveValidSnapshot(named: "filterView_content_device_\(container.device.hashValue)"))
                    }
                }
            }

            context("Show Error") {
                let flexibleSizeContainers = createFlexibleSizeContainers(tweets: UnitTestUtils.genereteTweet(5), hasError: true)

                flexibleSizeContainers.forEach { container in
                    beforeEach {
                        // Access the view to trigger the viewDidLoad().
                        _ = container.parent.view
                        _ = container.child.view
                    }

                    it("should show tweets \(container.device.hashValue)") {
                        expect(container.parent).to(haveValidSnapshot(named: "filterView_error_device_\(container.device.hashValue)"))
                    }
                }
            }
        }
    }

    let devices: [Device] = [
        .phone4inch,
        .phone47inch,
        .phone55inch,
        .phone58inch,
        .pad
    ]

    private func createFlexibleSizeContainers(tweets: [Tweet], hasError: Bool) -> [FlexibleSizeContainer] {
        return devices.map { device in
            let filterVC = FilterView()

            let presenter = FilterPresenterMock()
            filterVC.presenter = presenter
            presenter.view = filterVC
            presenter.tweets = tweets
            presenter.showError = hasError

            let (parent, child) = traitControllers(device: device, orientation: .portrait, child: filterVC)
            return FlexibleSizeContainer(parent: parent, child: child, device: device)
        }
    }

    private final class FilterPresenterMock: FilterPresenterProtocol {
        var view: (FilterViewProtocol & Stateful)?
        var interactor: FilterInteractorInputProtocol?
        var router: FilterRouterProtocol?

        var tweets: [Tweet] = []
        var showError = false

        func viewWillAppear() {
            guard !showError else {
                let filler = EmptyFiller(title: "Error!",
                                         subTile: "Sorry,\nsomething wrong happened.",
                                         actionName: "Try Again")
                view?.transition(toState: .empty(filler))
                return
            }

            if tweets.isEmpty {
                let filler = EmptyFiller(title: "Build your stream",
                                         subTile: "Type something to\nfollow news",
                                         actionName: nil)
                view?.transition(toState: .empty(filler))
            } else {
                view?.transition(toState: .content)
            }
        }

        func numberOfItems(inSection section: Int) -> Int {
            return tweets.count
        }

        func setContent(toView view: TweetDisplayable, atIndexPath indexPath: IndexPath) {
            guard let tweet = tweets.get(indexPath.row) else { return }
            view.configure(withTweet: TweetViewModel(tweet: tweet))
        }

        func filterTouched(with text: String?) {}
        func tryAgainTouched() {}
    }
}

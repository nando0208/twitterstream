//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Unbox
@testable import twitterstream

final class FilterInteractorSpec: QuickSpec {

    // MARK: - Mocks

    fileprivate class PresenterMock: FilterInteractorOutputProtocol {
        var receivedData = false
        func startReceiveData() {
            reconnecting = false
            receivedData = true
        }

        var receivedError = false
        func receivedError(_ error: Error?) {
            receivedError = true
            reconnecting = false
        }

        var currentTweets = 0
        func didUpdatedTweets(inserted: [IndexPath], deleted: [IndexPath]) {
            currentTweets += (inserted.count - deleted.count)
        }

        var reconnecting = false
        func tryingReconnect() {
            reconnecting = true
        }
    }

    fileprivate class APIDataManagerMock: FilterAPIDataManagerInputProtocol {

        var closure: TaskClosure?
        var error = false
        var waves = [4]
        func startStream(filterKeys: [String], andUserID userID: String, callBack: @escaping TaskClosure) {
            closure = callBack
            waves.forEach { count in
                callBack(.newData(UnitTestUtils.genereteTweet(count)))
            }
            if error {
                callBack(.failure(nil))
            }
        }
    }

    fileprivate class LocalDataManagerMock: FilterLocalDataManagerInputProtocol {
        var userID: String? { return "" }
    }

    // MARK: - Tests

    // swiftlint:disable function_body_length
    override func spec() {
        describe("FilterInteractor") {

            // MARK: - Properties

            var sut: FilterInteractor!
            var presenterMock: PresenterMock!
            var apiMock: APIDataManagerMock!

            beforeEach {
                sut = FilterInteractor()
                sut.localDatamanager = LocalDataManagerMock()
                apiMock = APIDataManagerMock()
                sut.APIDataManager = apiMock
                presenterMock = PresenterMock()
                sut.presenter = presenterMock
            }

            context("should success in getting tweets") {
                beforeEach {
                    apiMock.waves = [4]
                    apiMock.error = false
                    sut.filter(text: "Transferwise")
                }

                it("fetched tweets") {
                    expect(presenterMock.currentTweets).to(beGreaterThan(0))
                    expect(presenterMock.receivedData).to(beTrue())
                    expect(sut.tweet(at: 0)).toNot(beNil())
                }

                it("correct number of tweets") {
                    expect(presenterMock.currentTweets).to(be(sut.numberOfTweets()))
                    expect(presenterMock.currentTweets).to(be(4))
                }

                it("didn't get any error") {
                    expect(presenterMock.receivedError).to(beFalse())
                }

                afterEach {
                    presenterMock.currentTweets = 0
                    presenterMock.receivedData = false
                    presenterMock.receivedError = false
                }
            }

            context("should failued after get some tweets") {
                beforeEach {
                    apiMock.waves = [4]
                    apiMock.error = true
                    sut.filter(text: "Transferwise")
                }

                it("get error") {
                    expect(presenterMock.receivedError).to(beTrue())
                }

                it("get data before get error") {
                    expect(presenterMock.receivedData).to(beTrue())
                }

                it("didn't lose tweets before error") {
                    expect(presenterMock.currentTweets).to(be(4))
                }

                afterEach {
                    presenterMock.currentTweets = 0
                    presenterMock.receivedData = false
                    presenterMock.receivedError = false
                }
            }

            context("should delete tweets to be consistent") {
                beforeEach {
                    apiMock.waves = [4, 10, 2, 3, 1]
                    apiMock.error = false
                    sut.filter(text: "Transferwise")
                }

                it("keep with the same qtd of tweets") {
                    expect(presenterMock.currentTweets).to(be(sut.numberOfTweets()))
                }

                it("don't have more than 5 tweets(limit)") {
                    expect(presenterMock.currentTweets).to(beLessThan(6))
                    expect(sut.tweet(at: 5)).to(beNil())
                }

                afterEach {
                    presenterMock.currentTweets = 0
                    presenterMock.receivedData = false
                    presenterMock.receivedError = false
                }
            }

            context("Stop and clean data") {
                beforeEach {
                    apiMock.waves = [4]
                    apiMock.error = false
                    sut.filter(text: "Transferwise")
                    apiMock.closure?(.newData(UnitTestUtils.genereteTweet(5)))
                    sut.stopStream()
                }

                it("zero tweets") {
                    expect(sut.numberOfTweets()).to(be(0))
                    expect(sut.tweet(at: 0)).to(beNil())
                }
            }

            context("Stop and reconnect") {
                beforeEach {
                    apiMock.waves = [2]
                    apiMock.error = false
                    sut.filter(text: "Transferwise")
                    apiMock.closure?(.failure(nil))
                    sut.tryStartStreamAgain()
                }

                it("get tweets after reconect") {
                    expect(presenterMock.currentTweets).to(be(4))
                    expect(sut.numberOfTweets()).to(be(4))
                }
            }

            afterEach {
                sut = nil
                presenterMock = nil
                apiMock = nil
            }
        }
    }
}

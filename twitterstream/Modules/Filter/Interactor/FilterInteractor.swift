//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

final class FilterInteractor: FilterInteractorInputProtocol {

    // MARK: - Properties

    weak var presenter: FilterInteractorOutputProtocol?
    var APIDataManager: FilterAPIDataManagerInputProtocol?
    var localDatamanager: FilterLocalDataManagerInputProtocol?

    private var tweets: [Tweet] = []
    private let limit = 5
    private var stoped = true
    private var currentText = ""

    // MARK: - Initialization

    init() {}

    func filter(text: String) {
        currentText = text
        guard let userID = localDatamanager?.userID else {
            return
        }

        stoped = false
        let words = text
            .components(separatedBy: " ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        APIDataManager?.startStream(filterKeys: words, andUserID: userID) {[weak self] result in
            switch result {
            case .newData(let tweets):
                self?.received(news: tweets)
            case .failure(let error):
                self?.handleError(error)
            case .needToReconnect:
                self?.presenter?.tryingReconnect()
                DispatchQueue.main.sync {
                    self?.tryStartStreamAgain()
                }
            }
        }
    }

    private func received(news: [Tweet]) {
        guard !stoped else { return }
        presenter?.startReceiveData()

        let news = news.prefix(min(limit, news.count))

        var deleteCount = ( tweets.count + news.count ) - limit
        deleteCount = max(0, deleteCount)

        let deletedTweets = (1 ..< deleteCount + 1)
            .map { IndexPath(item: tweets.count - $0, section: 0) }

        let insertedTweets = (0 ..< news.count)
            .map { IndexPath(item: $0, section: 0) }

        tweets.removeLast(deleteCount)
        tweets.insert(contentsOf: news, at: 0)
        presenter?.didUpdatedTweets(inserted: insertedTweets,
                                    deleted: deletedTweets)
    }

    private func handleError(_ error: Error?) {
        stoped = true
        presenter?.receivedError(error)
    }

    func tryStartStreamAgain() {
        stoped = true
        filter(text: currentText)
    }

    func stopStream() {
        stoped = true
        tweets = []
    }

    func numberOfTweets() -> Int {
        return tweets.count
    }

    func tweet(at index: Int) -> TweetViewModel? {
        guard let tweet = tweets.get(index) else { return nil }
        return TweetViewModel(tweet: tweet)
    }
}

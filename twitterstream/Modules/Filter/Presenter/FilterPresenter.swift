//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

final class FilterPresenter: FilterPresenterProtocol {

    // MARK: - Properties

    weak var view: (FilterViewProtocol & Stateful)?
    var interactor: FilterInteractorInputProtocol?
    var router: FilterRouterProtocol?

    // MARK: Initialization

    init() {}

    func viewWillAppear() {
        let filler = EmptyFiller(title: "Build your stream",
                                 subTile: "Type something to\nfollow news",
                                 actionName: nil)
        view?.transition(toState: .empty(filler))
    }

    // MARK: - DataSource

    func numberOfItems(inSection section: Int) -> Int {
        return interactor?.numberOfTweets() ?? 0
    }

    func setContent(toView view: TweetDisplayable, atIndexPath indexPath: IndexPath) {
        guard let tweet = interactor?.tweet(at: indexPath.row) else { return }
        view.configure(withTweet: tweet)
    }

    // MARK: - Actions

    func filterTouched(with text: String?) {
        interactor?.stopStream()
        view?.transition(toState: .loading)
        guard let text = text else { return }
        interactor?.filter(text: text)
    }

    func tryAgainTouched() {
        interactor?.stopStream()
        view?.transition(toState: .loading)
        interactor?.tryStartStreamAgain()
    }
}

// MARK: - FilterInteractorOutputProtocol

extension FilterPresenter: FilterInteractorOutputProtocol {
    func startReceiveData() {
        DispatchQueue.main.sync {
            view?.transition(toState: .content)
        }
    }

    func receivedError(_ error: Error?) {
        var message = "Sorry,\nsomething wrong happened."
        if let error = error as? StreamError, error == .noInternetConnection {
            message = "You don't have\ninternet connection."
        }
        let filler = EmptyFiller(title: "Error!", subTile: message, actionName: "Try Again")
        DispatchQueue.main.sync {
            view?.adapt(toState: .error(filler))
        }
    }

    func tryingReconnect() {
        DispatchQueue.main.sync {
            view?.adapt(toState: .reconnecting)
        }
    }

    func didUpdatedTweets(inserted: [IndexPath], deleted: [IndexPath]) {
        DispatchQueue.main.sync {
            view?.updateIndices(toInsert: inserted, toDelete: deleted)
        }
    }
}

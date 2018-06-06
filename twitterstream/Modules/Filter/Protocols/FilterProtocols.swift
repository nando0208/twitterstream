//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

// MARK: - Protocols

// MARK: FilterPresenterProtocol
// VIEW -> PRESENTER
protocol FilterPresenterProtocol: class {

    // MARK: - Properties

    var view: (FilterViewProtocol & Stateful)? { get set }
    var interactor: FilterInteractorInputProtocol? { get set }
    var router: FilterRouterProtocol? { get set }

    func viewWillAppear()

    // MARK: - DataSource

    func numberOfItems(inSection section: Int) -> Int
    func setContent(toView view: TweetDisplayable, atIndexPath indexPath: IndexPath)

    // MARK: - Actions

    func filterTouched(with text: String?)
    func tryAgainTouched()
}

// MARK: FilterViewProtocol
// PRESENTER -> VIEW
protocol FilterViewProtocol: class {

    // MARK: - Properties

    var presenter: FilterPresenterProtocol? { get set }

    func updateIndices(toInsert: [IndexPath], toDelete: [IndexPath])
}

// MARK: FilterRouterProtocol
// PRESENTER -> ROUTER
protocol FilterRouterProtocol: class {

    // MARK: - Presentation

    static func presentFilterModule() -> UIViewController?
}

// MARK: FilterInteractorInputProtocol
// PRESENTER -> INTERACTOR
protocol FilterInteractorInputProtocol: class {

    // MARK: - Properties

    var presenter: FilterInteractorOutputProtocol? { get set }
    var APIDataManager: FilterAPIDataManagerInputProtocol? { get set }
    var localDatamanager: FilterLocalDataManagerInputProtocol? { get set }

    // MARK: Content

    func numberOfTweets() -> Int
    func tweet(at index: Int) -> TweetViewModel?
    func filter(text: String)
    func stopStream()
    func tryStartStreamAgain()
}

// MARK: FilterAPIDataManagerInputProtocol
// INTERACTOR -> APIDATAMANAGER
protocol FilterAPIDataManagerInputProtocol: class {
    func startStream(filterKeys: [String], andUserID userID: String, callBack: @escaping TaskClosure)
}

// MARK: FilterLocalDataManagerInputProtocol
// INTERACTOR -> LOCALDATAMANAGER
protocol FilterLocalDataManagerInputProtocol: class {
    var userID: String? { get }
}

// MARK: FilterInteractorOutputProtocol
// INTERACTOR -> PRESENTER
protocol FilterInteractorOutputProtocol: class {
    func startReceiveData()
    func receivedError(_ error: Error?)
    func didUpdatedTweets(inserted: [IndexPath], deleted: [IndexPath])
    func tryingReconnect()
}

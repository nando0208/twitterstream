//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import TwitterKit

// MARK: - Protocols

// MARK: LoginPresenterProtocol
// VIEW -> PRESENTER
protocol LoginPresenterProtocol: class {

    // MARK: - Properties

    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }

    func viewDidAppear()
    func finishedLogin(session: TWTRSession?, error: Error?)
}

// MARK: LoginViewProtocol
// PRESENTER -> VIEW
protocol LoginViewProtocol: class {

    // MARK: - Properties

    var presenter: LoginPresenterProtocol? { get set }

    func showLoginButton()
}

// MARK: LoginRouterProtocol
// PRESENTER -> ROUTER
protocol LoginRouterProtocol: class {

    // MARK: - Presentation

    static func presentLoginModule() -> UIViewController?
    func showFilter(from view: LoginViewProtocol?)
}

// MARK: LoginInteractorInputProtocol
// PRESENTER -> INTERACTOR
protocol LoginInteractorInputProtocol: class {

    // MARK: - Properties

    var presenter: LoginInteractorOutputProtocol? { get set }
    var APIDataManager: LoginAPIDataManagerInputProtocol? { get set }
    var localDatamanager: LoginLocalDataManagerInputProtocol? { get set }

    var isLoged: Bool { get }
}

// MARK: LoginAPIDataManagerInputProtocol
// INTERACTOR -> APIDATAMANAGER
protocol LoginAPIDataManagerInputProtocol: class { }

// MARK: LoginLocalDataManagerInputProtocol
// INTERACTOR -> LOCALDATAMANAGER
protocol LoginLocalDataManagerInputProtocol: class {
    var hasSession: Bool { get }
}

// MARK: LoginInteractorOutputProtocol
// INTERACTOR -> PRESENTER
protocol LoginInteractorOutputProtocol: class { }

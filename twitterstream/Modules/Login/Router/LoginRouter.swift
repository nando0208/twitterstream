//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

final class LoginRouter: LoginRouterProtocol {

    // MARK: - Presenting

    static func presentLoginModule() -> UIViewController? {

        // Generating module components
        let view: LoginViewProtocol = LoginView()
        let presenter: LoginPresenterProtocol & LoginInteractorOutputProtocol = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let router: LoginRouterProtocol = LoginRouter()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager

        return view as? UIViewController
    }

    func showFilter(from view: LoginViewProtocol?) {
        guard let filterView = FilterRouter.presentFilterModule() else { return }
        let fromVC = view as? UIViewController
        fromVC?.show(filterView, sender: nil)
    }
}

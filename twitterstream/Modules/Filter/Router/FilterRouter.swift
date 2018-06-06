//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

final class FilterRouter: FilterRouterProtocol {

    // MARK: - Presenting

    static func presentFilterModule() -> UIViewController? {

        // Generating module components
        let view: (FilterViewProtocol & Stateful) = FilterView()
        let presenter: FilterPresenterProtocol & FilterInteractorOutputProtocol = FilterPresenter()
        let interactor: FilterInteractorInputProtocol = FilterInteractor()
        let APIDataManager: FilterAPIDataManagerInputProtocol = FilterAPIDataManager()
        let localDataManager: FilterLocalDataManagerInputProtocol = FilterLocalDataManager()
        let router: FilterRouterProtocol = FilterRouter()

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
}

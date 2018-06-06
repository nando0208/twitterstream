//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import TwitterKit

final class LoginPresenter: LoginPresenterProtocol {

    // MARK: - Properties

    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?

    func viewDidAppear() {
        if interactor?.isLoged ?? false {
            router?.showFilter(from: view)
        } else {
            view?.showLoginButton()
        }
    }

    func finishedLogin(session: TWTRSession?, error: Error?) {
        router?.showFilter(from: view)
    }
}

// MARK: - LoginInteractorOutputProtocol

extension LoginPresenter: LoginInteractorOutputProtocol {

}

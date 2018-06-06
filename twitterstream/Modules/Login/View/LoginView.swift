//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import TwitterKit
import Cartography

final class LoginView: UIViewController {

    // MARK: - Outlets

    // MARK: - Properties

    var loginBtn: TWTRLogInButton?
    var presenter: LoginPresenterProtocol?

    // MARK: - View's Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
        view.backgroundColor = .white
    }

    // MARK: - Actions
}

// MARK: - LoginViewProtocol

extension LoginView: LoginViewProtocol {
    func showLoginButton() {
        guard let presenter = presenter else { return }

        if loginBtn == nil {
            let button = TWTRLogInButton(logInCompletion: presenter.finishedLogin)
            view.addSubview(button)
            loginBtn = button
        }

        guard let button = loginBtn else { return }
        constrain(view, button) { viewPx, buttonPx in
            buttonPx.center == viewPx.center
        }
    }
}

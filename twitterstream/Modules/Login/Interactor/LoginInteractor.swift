//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

final class LoginInteractor: LoginInteractorInputProtocol {

    // MARK: - Properties

    weak var presenter: LoginInteractorOutputProtocol?
    var APIDataManager: LoginAPIDataManagerInputProtocol?
    var localDatamanager: LoginLocalDataManagerInputProtocol?

    var isLoged: Bool { return localDatamanager?.hasSession ?? false }
}

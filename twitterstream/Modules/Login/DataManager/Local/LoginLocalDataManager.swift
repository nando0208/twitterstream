//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import TwitterKit

final class LoginLocalDataManager: LoginLocalDataManagerInputProtocol {
    var hasSession: Bool { return TWTRTwitter.sharedInstance().sessionStore.session() != nil }
}

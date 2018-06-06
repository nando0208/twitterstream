//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import TwitterKit

final class FilterLocalDataManager: FilterLocalDataManagerInputProtocol {

    // MARK: - Initialization
    var userID: String? {
        return TWTRTwitter.sharedInstance().sessionStore.session()?.userID
    }
    init() {}
}

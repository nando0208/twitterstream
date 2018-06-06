//
//  ErrorExtensions.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 18/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
}

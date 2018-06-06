//
//  TwitterRequest.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 21/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

enum TwitterRequest: ServiceRequest {
    case filter(keys: [String])

    var baseURL: String {
        return "https://stream.twitter.com/1.1/"
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "statuses/filter.json"
    }
    var parameters: [AnyHashable: Any]? {
        var params: [AnyHashable: Any] = [:]
        if case let .filter(keys) = self {
            params["track"] = keys.joined(separator: ",")
        }
        return params
    }
}

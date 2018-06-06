//
//  ServiceRequest.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 21/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import TwitterKit

public enum HTTPMethod: String {
    case post = "POST"
}

protocol ServiceRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [AnyHashable: Any]? { get }
}

extension ServiceRequest {
    func toRequest(with userID: String? = nil) -> URLRequest {
        var clientError: NSError?
        let client = TWTRAPIClient(userID: userID)
        return client.urlRequest(withMethod: method.rawValue,
                                 urlString: baseURL + path,
                                 parameters: parameters,
                                 error: &clientError)
    }
}

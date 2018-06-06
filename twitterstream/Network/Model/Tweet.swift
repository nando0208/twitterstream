//
//  Tweet.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 15/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Unbox

struct Tweet: Unboxable {
    let text: String?
    let user: User?

    init(unboxer: Unboxer) throws {
        text = try? unboxer.unbox(key: "text")
        user = try? unboxer.unbox(key: "user")
    }
}

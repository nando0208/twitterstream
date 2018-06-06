//
//  User.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 15/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Unbox

struct User: Unboxable {
    let name: String?
    let userName: String?
    let photo: String?

    init(unboxer: Unboxer) throws {
        name = unboxer.unbox(key: "name")
        userName = unboxer.unbox(key: "screen_name")
        photo = unboxer.unbox(key: "profile_image_url_https")
    }
}

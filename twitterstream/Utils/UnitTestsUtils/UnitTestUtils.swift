//
//  UnitTestUtils.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 23/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import Unbox
@testable import twitterstream

struct FlexibleSizeContainer {
    let parent: UIViewController
    let child: UIViewController
    let device: Device
}

final class UnitTestUtils {
    static func genereteTweet(_ count: Int) -> [Tweet] {
        return (0 ..< count)
            .compactMap { _ in twetJsonSample.data(using: .utf8) }
            .compactMap { (try? JSONSerialization.jsonObject(with: $0, options: [])) as? [String: Any] }
            .compactMap { try? Tweet(unboxer: Unboxer(dictionary: $0)) }

    }
}

// swiftlint:disable line_length
private let twetJsonSample = "{\"text\":\"We're happy to announce we're now 1000 employees strong! So how did we grow so rapidly and what are the lessons we've learnt? We asked some of our people for their perspective, read more here:\",\"user\":{\"name\":\"TransferWise\",\"screen_name\":\"TransferWise\",\"profile_image_url_https\":\"https:\\/\\/pbs.twimg.com\\/profile_images\\/927941666069245953\\/ej9vkKwi_normal.jpg\"}}"

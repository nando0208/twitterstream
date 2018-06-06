//
//  TweetViewModel.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 15/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

struct TweetViewModel {
    private let tweet: Tweet
    private var user: User? { return tweet.user }

    init(tweet: Tweet) {
        self.tweet = tweet
    }

    var text: String? { return tweet.text }
    var name: String? { return user?.name }
    var userName: String? {
        guard let userName = user?.userName else { return nil }
        return "@" + userName
    }
    var photoUrl: URL? { return URL(string: user?.photo ?? "") }

    var attibutedTitle: NSAttributedString {
        let title = NSMutableAttributedString()

        if let name = name {
            let attributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 13.0),
                .foregroundColor: UIColor.blackTwitter
            ]
            title.append(NSAttributedString(string: name, attributes: attributes))
        }

        if let userName = userName {
            let attributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 13.0),
                .foregroundColor: UIColor.gray
            ]
            title.append(NSAttributedString(string: " " + userName, attributes: attributes))
        }

        return title
    }
}

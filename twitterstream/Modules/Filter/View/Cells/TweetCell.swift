//
//  TweetCell.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 15/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TweetDisplayable {
    func configure(withTweet tweet: TweetViewModel)
}

final class TweetCell: UITableViewCell, TweetDisplayable {

    @IBOutlet private weak var userPhoto: UIImageView?
    @IBOutlet private weak var details: UILabel?
    @IBOutlet private weak var tweetContent: UILabel?
    @IBOutlet private weak var activity: UIActivityIndicatorView?

    private var imageRequest: RequestReceipt?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageRequest?.request.cancel()
        imageRequest = nil
        userPhoto?.image = nil
    }

    func configure(withTweet tweet: TweetViewModel) {
        details?.attributedText = tweet.attibutedTitle
        tweetContent?.text = tweet.text

        if let url = tweet.photoUrl {
            let filter = AspectScaledToFillSizeCircleFilter(size: userPhoto?.frame.size ?? .zero)
            let request = URLRequest(url: url)
            imageRequest = ImageDownloader.default.download(request, filter: filter) { [weak self] response in
                self?.activity?.stopAnimating()
                self?.userPhoto?.image = response.result.value
            }
        } else {
            activity?.stopAnimating()
        }
    }
}

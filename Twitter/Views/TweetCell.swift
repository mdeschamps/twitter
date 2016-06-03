//
//  TweetCell.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit
import AlamofireImage

protocol TweetCellDelegate: class {
  func onAvatarTapped(cell: TweetCell)
}

class TweetCell: UITableViewCell {

  @IBOutlet weak var socialProofView: UIView!
  @IBOutlet weak var mediaView: UIView!

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var mediaImage: UIImageView!
  @IBOutlet weak var retweetedByLabel: UILabel!

  weak var delegate: TweetCellDelegate?

  weak var tweet: Tweet? {
    didSet {
      guard let tweet = self.tweet else {
        return
      }

      showSocialProof(tweet)

      var tweetOrRetweet = tweet
      if let retweet = tweet.retweetedTweet {
        tweetOrRetweet = retweet
      }
      showTweet(tweetOrRetweet)

      showTweetMedia(tweet)
    }
  }

  func onAvatarTapped(sender: AnyObject) {
    delegate?.onAvatarTapped(self)
  }

  private func showTweet(tweet: Tweet) {
    nameLabel.text = tweet.author.name
    screenNameLabel.text = tweet.author.formattedScreenName
    if let url = NSURL(string:tweet.author.profileImageLargeURL) {
      avatarImage.af_setImageWithURL(url)
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAvatarTapped))
      avatarImage.addGestureRecognizer(gestureRecognizer)
    } else {
      avatarImage.image = nil
    }

    statusLabel.attributedText = tweet.attributedStatus

    if let timestampDelta = NSDate().offsetFrom(tweet.createdAt) {
      timestampLabel.text = timestampDelta
    } else {
      timestampLabel.text = tweet.shortDisplayCreateAt
    }
  }

  private func showSocialProof(tweet: Tweet) {
    if tweet.isRetweet {
      socialProofView.hidden = false
      retweetedByLabel.text = String(format:"%@ Retweeted", tweet.author.name)
    } else {
      socialProofView.hidden = true
      retweetedByLabel.text = ""
    }
  }

  private func showTweetMedia(tweet: Tweet) {
    if let media = tweet.media, first = media.first {
      mediaView.hidden = false
      mediaImage.hidden = false
      mediaImage.clipsToBounds = true
      mediaImage.af_setImageWithURL(first.mediaUrlHttps!)
    } else {
      mediaView.hidden = true
      mediaImage.hidden = true
      mediaImage.image = nil
    }
  }

}

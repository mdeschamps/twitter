//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

  @IBOutlet weak var socialProofView: UIView!
  @IBOutlet weak var tweetView: UIView!
  @IBOutlet weak var mediaView: UIView!
  @IBOutlet weak var statsView: UIView!
  @IBOutlet weak var actionsView: UIView!

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var mediaImage: UIImageView!

  @IBOutlet weak var retweetedByLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var likesCountLabel: UILabel!

  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var likeButton: UIButton!

  private let sectionBorder = Border(
    size: 0.3,
    color: UIColor(white: 0.667, alpha: 0.6),
    offset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))

  var tweet: Tweet?

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let tweet = self.tweet else {
      return
    }

    showTweet(tweet)
  }

  @IBAction func onProfileTapped(sender: UITapGestureRecognizer) {
    var tweetOrRetweet = tweet
    if let retweet = tweet?.retweetedTweet {
      tweetOrRetweet = retweet
    }

    let profileVC = UserViewController()
    profileVC.user = tweetOrRetweet?.author

    navigationController?.pushViewController(profileVC, animated: true)
  }

  @IBAction func onReplyTapped(sender: UIButton) {
    let composeVC = ComposeViewController()
    composeVC.inReplyToTweet = tweet
    composeVC.delegate = self

    presentViewController(composeVC, animated: true, completion: nil)
  }

  @IBAction func onRetweetTapped(sender: UIButton) {
    guard let tweet = tweet else {
      return
    }

    tweet.isRetweeted = !tweet.isRetweeted
    let completionBlock: (response: TwitterAPIResponse) -> Void = { response in
      if response == .Failure {
        tweet.isRetweeted = !tweet.isRetweeted
        self.showTweetStats(tweet)
        self.showActions(tweet)
      }
    }

    if tweet.isRetweeted {
      TwitterAPIClient().retweet(tweetID: tweet.tweetID, completion: completionBlock)
    } else {
      TwitterAPIClient().unretweet(tweetID: tweet.tweetID, completion: completionBlock)
    }

    showTweetStats(tweet)
    showActions(tweet)
  }

  @IBAction func onLikeTapped(sender: UIButton) {
    guard let tweet = tweet else {
      return
    }

    tweet.isLiked = !tweet.isLiked

    let completionBlock: (response: TwitterAPIResponse) -> Void = { response in
      if response == .Failure {
        tweet.isLiked = !tweet.isLiked
        self.showTweetStats(tweet)
        self.showActions(tweet)
      }
    }

    if tweet.isLiked {
      TwitterAPIClient().likeTweet(tweetID: tweet.tweetID, completion: completionBlock)
    } else {
      TwitterAPIClient().unlikeTweet(tweetID: tweet.tweetID, completion: completionBlock)
    }
    
    showTweetStats(tweet)
    showActions(tweet)
  }

  private func showTweet(tweet: Tweet) {
    var tweetOrRetweet: Tweet = tweet
    if let retweet = tweet.retweetedTweet {
      tweetOrRetweet = retweet
    }

    showSocialProof(tweet)
    showTweetMedia(tweet)
    showTweetStats(tweetOrRetweet)
    showActions(tweet)

    nameLabel.text = tweetOrRetweet.author.name
    screenNameLabel.text = tweetOrRetweet.author.formattedScreenName
    statusLabel.attributedText = tweetOrRetweet.attributedStatus

    if let url = NSURL(string:tweetOrRetweet.author.profileImageLargeURL) {
      avatarImage.af_setImageWithURL(url)
    } else {
      avatarImage.image = nil
    }

    timestampLabel.text = tweetOrRetweet.fullDisplayCreateAt
  }

  private func showSocialProof(tweet: Tweet) {
    if tweet.isRetweet {
      socialProofView.hidden = false
      retweetedByLabel.text = String(format:"%@ Retweeted",tweet.author.name)
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
      mediaImage.af_setImageWithURL(first.mediaUrl!)
    } else {
      mediaView.hidden = true
      mediaImage.hidden = true
      mediaImage.image = nil
    }
  }

  private func showTweetStats(tweet: Tweet) {
    if tweet.retweetCount > 0 || tweet.likeCount > 0 {
      statsView.hidden = false
      statsView.borderTop = sectionBorder

      retweetCountLabel.text = String(tweet.retweetCount)
      likesCountLabel.text = String(tweet.likeCount)
    } else {
      statsView.hidden = true
    }
  }

  private func showActions(tweet: Tweet) {
    actionsView.borderTop = sectionBorder
    actionsView.borderBottom = sectionBorder

    if tweet.isRetweeted {
      retweetButton.tintColor = UIColor.greenColor()
    } else {
      retweetButton.tintColor = UIColor.lightGrayColor()
    }

    if tweet.isLiked {
      likeButton.tintColor = UIColor.redColor()
    } else {
      likeButton.tintColor = UIColor.lightGrayColor()
    }
  }
}

extension TweetDetailsViewController: ComposeDelegate {
  func didTweetSend(tweet: Tweet) {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  func didTweetCancel() {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}

//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

protocol TimelineViewDelegate: class {
  func loadTweets(sinceID sinceID: String?, maxID: String?, completion: (response: TweetsResponse) -> Void)
}

class TimelineViewController: UIViewController {

  @IBOutlet weak var tweetsTableView: TweetsTableView!

  weak var timelineDelegate: TimelineViewDelegate?

  private var loading: Bool = false
  private var isLoading: Bool {
    set {
      objc_sync_enter(self)
      loading = newValue
      objc_sync_exit(self)
    }
    get {
      objc_sync_enter(self)
      let retVal = loading
      objc_sync_exit(self)
      return retVal
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tweetsTableView.tweetsDelegate = self
    timelineDelegate?.loadTweets(sinceID: nil, maxID: nil){ response in
      self.handleTweetResponse(sinceID: nil, maxID: nil, response: response)
    }
  }

  internal func handleTweetResponse(sinceID sinceID: String?, maxID: String?, response: TweetsResponse) {
    self.isLoading = false

    switch response {
    case .Failure:
      break

    case .Success(let tweets):
      switch (self.tweetsTableView.tweets, maxID, sinceID) {

      // Load Older
      case (var currentTweets?, _?, nil):
        currentTweets.appendContentsOf(tweets)
        self.tweetsTableView.tweets = currentTweets

      // Load Newer
      case (var currentTweets?, nil, _?):
        currentTweets.insertContentsOf(tweets, at: 0)
        self.tweetsTableView.tweets = currentTweets

      default:
        self.tweetsTableView.tweets = tweets
      }
    }
  }
}

extension TimelineViewController: TweetsTableDelegate {

  func didSelectTweet(tweet: Tweet) {
    let detailsVC = TweetDetailsViewController()
    detailsVC.tweet = tweet
    
    navigationController?.pushViewController(detailsVC, animated: true)
  }

  func didSelectUser(user: User) {
    let profileVC = UserViewController()
    profileVC.user = user

    navigationController?.pushViewController(profileVC, animated: true)
  }

  func loadTweetsOlderThan(tweet: Tweet) -> Bool {
    guard !isLoading else {
      return false
    }

    let maxID = tweet.tweetID

    self.isLoading = true
    timelineDelegate?.loadTweets(sinceID: nil, maxID: maxID) { response in
      self.handleTweetResponse(sinceID: nil, maxID: maxID, response: response)
    }
    return true
  }
}
//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class HomeTimelineViewController: TimelineViewController, TimelineViewDelegate {

  weak var containerDelegate: ContainerViewDelegate?
  var pullToRefreshControl: UIRefreshControl?

  override func viewDidLoad() {
    timelineDelegate = self

    super.viewDidLoad()

    pullToRefreshControl = UIRefreshControl()
    pullToRefreshControl?.addTarget(self, action: #selector(pullNewTweets), forControlEvents: .ValueChanged)
    tweetsTableView.insertSubview(pullToRefreshControl!, atIndex: 0)
  }

  @objc private func pullNewTweets(refreshControl: UIRefreshControl?) {
    var sinceID: String? = nil
    if let firstTweet = self.tweetsTableView.tweets?.first {
      sinceID = firstTweet.tweetID
    }

    loadTweets(sinceID: sinceID, maxID: nil) { response in
      refreshControl?.endRefreshing()

      self.handleTweetResponse(sinceID: sinceID, maxID: nil, response: response)
    }
  }

  @IBAction func onMenuTapped(sender: AnyObject) {
    containerDelegate?.toggleSideBar()
  }

  @IBAction func onComposeTapped(sender: AnyObject) {
    let composeVC = ComposeViewController()
    composeVC.delegate = self
    
    presentViewController(composeVC, animated: true, completion: nil)
  }

  func loadTweets(sinceID sinceID: String?, maxID: String?, completion: (response: TweetsResponse) -> Void) {
    TwitterAPIClient().homeTimeline(sinceID: sinceID, maxID: maxID) { (response) in
      completion(response: response)
    }
  }
}

extension HomeTimelineViewController: ComposeDelegate {
  func didTweetSend(tweet: Tweet) {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    tweetsTableView.addTweet(tweet)
  }

  func didTweetCancel() {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
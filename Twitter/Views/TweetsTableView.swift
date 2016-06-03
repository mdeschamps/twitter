//
//  TweetsTableView.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

@objc protocol TweetsTableDelegate: class {
  func didSelectTweet(tweet: Tweet)
  func didSelectUser(user: User)
  optional func loadTweetsOlderThan(tweet: Tweet) -> Bool
}

class TweetsTableView: UITableView {

  weak var tweetsDelegate: TweetsTableDelegate?

  var tweets: [Tweet]? {
    didSet {
      removeLoadingFooterView()
      reloadData()
    }
  }

  private func setup(){
    registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "tweetcell")

    estimatedRowHeight = 100
    rowHeight = UITableViewAutomaticDimension
    dataSource = self
    delegate = self
  }

  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func insertLoadingFooterView(){
    let tableFooterView: UIView = UIView(frame: CGRectMake(0, 0, frame.size.width, 50))
    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    loadingView.startAnimating()
    loadingView.center = tableFooterView.center
    tableFooterView.addSubview(loadingView)
    self.tableFooterView = tableFooterView
  }

  private func removeLoadingFooterView(){
    tableFooterView?.removeFromSuperview()
  }

  func addTweet(tweet:Tweet, atIndex index: Int = 0) {
    tweets?.insert(tweet, atIndex: index)
    reloadData()
  }
}

extension TweetsTableView: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let
      cell = tableView.dequeueReusableCellWithIdentifier("tweetcell", forIndexPath: indexPath) as? TweetCell,
      tweet = tweets?[indexPath.row]
    else {
      return UITableViewCell()
    }

    if indexPath.row + 1 == tweets?.count ?? 1 {
      if tweetsDelegate?.loadTweetsOlderThan?(tweet) ?? false {
        insertLoadingFooterView()
      }
    }

    cell.tweet = tweet
    cell.delegate = self

    return cell
  }
}

extension TweetsTableView: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let tweet = tweets?[indexPath.row] else {
      return
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tweetsDelegate?.didSelectTweet(tweet)
  }
}

extension TweetsTableView: TweetCellDelegate {

  func onAvatarTapped(cell: TweetCell) {
    guard let indexPath = indexPathForCell(cell), tweet = tweets?[indexPath.row] else {
      return
    }

    var tweetOrRetweet = tweet
    if let retweet = tweet.retweetedTweet {
      tweetOrRetweet = retweet
    }
    tweetsDelegate?.didSelectUser(tweetOrRetweet.author)
  }
}

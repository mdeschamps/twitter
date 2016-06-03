//
//  UserViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class UserViewController: TimelineViewController {

  @IBOutlet weak var headerView: ProfileHeaderView!
  @IBOutlet weak var statsView: UIView!
  @IBOutlet weak var actionsView: UIView!
  @IBOutlet weak var actionsWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var tweetCountLabel: UILabel!
  @IBOutlet weak var friendsCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!

  weak var user: User?

  override func viewDidLoad() {
    timelineDelegate = self

    super.viewDidLoad()

    guard let user = self.user else {
      return
    }
    title = user.formattedScreenName
    headerView.user = user

    let border = Border(
      size: 0.3,
      color: UIColor.lightGrayColor(),
      offset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

    statsView.borderBottom = border
    tweetCountLabel.text = String(user.tweetCount)
    friendsCountLabel.text = String(user.friendCount)
    followersCountLabel.text = String(user.followerCount)

    tweetsTableView.borderTop = border
  }
}

extension UserViewController: TimelineViewDelegate {

  func loadTweets(sinceID sinceID: String?, maxID: String?, completion: (response: TweetsResponse) -> Void) {
    guard let user = self.user else {
      return
    }
    TwitterAPIClient().loadTweetsForUserID(userID: user.userID, sinceID: sinceID, maxID: maxID) { (response) in
      completion(response: response)
    }
  }
}
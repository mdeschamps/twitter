//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class MentionsViewController: HomeTimelineViewController {

  override func loadTweets(sinceID sinceID: String?, maxID: String?, completion: (response: TweetsResponse) -> Void) {
    TwitterAPIClient().mentionsTimeline(sinceID: sinceID, maxID: maxID) { (response) in
      completion(response: response)
    }
  }
}

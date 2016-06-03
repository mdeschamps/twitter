//
//  TwitterAPIClient+Compose.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

enum TweetUpdate {
  case Success(tweet: Tweet)
  case Failure
}

extension TwitterAPIClient {
  
  func tweetStatus(status status: String, inReplyToTweetID: String?, completion: (response: TweetUpdate) -> Void) {
    let updateUrl = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")!

    var params = [TwitterAPIParams.Status: status]
    if let inReplyToTweetID = inReplyToTweetID {
      params[.InReplyTo] = inReplyToTweetID
    }

    fireRequest("POST", endpointUrl: updateUrl, parameters: params) { (jsonOrNil) -> Void in
      guard let json = jsonOrNil else {
        completion(response: .Failure)
        return
      }

      if let jsonDictionary = json as? [NSObject : AnyObject] {
        completion(response: .Success(tweet: Tweet(JSONDictionary: jsonDictionary)))
      } else {
        completion(response: .Failure)
      }
    }
  }
}
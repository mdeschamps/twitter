//
//  TwitterAPIClient+Timeline.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

extension TwitterAPIClient {

  func homeTimeline(sinceID
    sinceID: String? = nil,
    maxID: String? = nil,
    completion: (response: TweetsResponse) -> Void)
  {
    let timelineUrl = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!

    var params: [TwitterAPIParams: String] = [:]
    if let sinceID = sinceID {
      params[.SinceID] = sinceID
    }
    if let maxID = maxID {
      params[.MaxID] = maxID
    }

    loadTweetsFromEndpoint(endpointURL: timelineUrl, parameters: &params, completion: completion)
  }

  func mentionsTimeline(sinceID
    sinceID: String? = nil,
    maxID: String? = nil,
    completion: (response: TweetsResponse) -> Void)
  {
    let mentionsUrl = NSURL(string: "https://api.twitter.com/1.1/statuses/mentions_timeline.json")!

    var params: [TwitterAPIParams: String] = [:]
    if let sinceID = sinceID {
      params[.SinceID] = sinceID
    }
    if let maxID = maxID {
      params[.MaxID] = maxID
    }

    loadTweetsFromEndpoint(endpointURL: mentionsUrl, parameters: &params, completion: completion)
  }

  func loadTweetsForUserID(userID
    userID: String,
    sinceID: String? = nil,
    maxID: String? = nil,
    completion: (response: TweetsResponse) -> Void)
  {
    let tweetsUrl = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")!

    var params = [TwitterAPIParams.UserID: userID]
    if let sinceID = sinceID {
      params[.SinceID] = sinceID
    }
    if let maxID = maxID {
      params[.MaxID] = maxID
    }

    loadTweetsFromEndpoint(endpointURL: tweetsUrl, parameters: &params, completion: completion)
  }

  private func loadTweetsFromEndpoint(endpointURL
    endpointURL: NSURL,
    inout parameters: [TwitterAPIParams: String],
    completion: (response: TweetsResponse) -> Void)
  {
    if (parameters[.MaxID] != nil) {
      parameters[.Count] = "21" // long story, stupid API
    }

    fireRequest(endpointUrl: endpointURL, parameters: parameters) { (jsonOrNil) -> (Void) in
      guard let json = jsonOrNil else {
        completion(response: .Failure)
        return
      }

      if let jsonArray = json as? [AnyObject] {
        var tweets = Tweet.tweetsWithJSONArray(jsonArray)
        if parameters[.MaxID] != nil && tweets.count > 0 {
          tweets.removeFirst() // see .Count above
        }
        completion(response: .Success(tweets: tweets))
      } else {
        completion(response: .Failure)
      }
    }
  }

}
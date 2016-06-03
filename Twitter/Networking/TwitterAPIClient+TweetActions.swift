//
//  TwitterAPIClient+TweetActions.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//
import Foundation
import TwitterKit

enum TwitterAPIResponse {
  case Success
  case Failure
}

extension TwitterAPIClient {

  func likeTweet(tweetID tweetID: String, completion: (response: TwitterAPIResponse) -> Void) {
    let likeEndpoint = NSURL(string: "https://api.twitter.com/1.1/favorites/create.json")!
    let params = [TwitterAPIParams.ID: tweetID]

    fireRequest("POST", endpointUrl: likeEndpoint, parameters: params) { (jsonOrNil) -> Void in
      if jsonOrNil == nil {
        completion(response: .Failure)
      } else {
        completion(response: .Success)
      }
    }
  }

  func unlikeTweet(tweetID tweetID: String, completion: (response: TwitterAPIResponse) -> Void) {
    let unlikeEndpoint = NSURL(string: "https://api.twitter.com/1.1/favorites/destroy.json")!
    let params = [TwitterAPIParams.ID: tweetID]

    fireRequest("POST", endpointUrl: unlikeEndpoint, parameters: params) { (jsonOrNil) -> Void in
      if jsonOrNil == nil {
        completion(response: .Failure)
      } else {
        completion(response: .Success)
      }
    }
  }

  func retweet(tweetID tweetID: String, completion: (response: TwitterAPIResponse) -> Void) {
    let retweetEndpoint = NSURL(string: "https://api.twitter.com/1.1/statuses/retweet.json")!
    let params = [TwitterAPIParams.ID: tweetID]

    fireRequest("POST", endpointUrl: retweetEndpoint, parameters: params) { (jsonOrNil) -> Void in
      if jsonOrNil == nil {
        completion(response: .Failure)
      } else {
        completion(response: .Success)
      }
    }
  }

  func unretweet(tweetID tweetID: String, completion: (response: TwitterAPIResponse) -> Void) {
    let unretweetEndpoint = NSURL(string: "https://api.twitter.com/1.1/statuses/unretweet.json")!
    let params = [TwitterAPIParams.ID: tweetID]

    fireRequest("POST", endpointUrl: unretweetEndpoint, parameters: params) { (jsonOrNil) -> Void in
      if jsonOrNil == nil {
        completion(response: .Failure)
      } else {
        completion(response: .Success)
      }
    }
  }

}
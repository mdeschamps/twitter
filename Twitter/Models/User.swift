//
//  User.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation
import TwitterKit

class User: TWTRUser {

  let bio: String
  let location: String
  let likeCount: Int
  let followerCount: Int
  let friendCount: Int
  let tweetCount: Int

  required init(JSONDictionary dictionary: [NSObject : AnyObject]) {
    if let likes = dictionary["favourites_count"] as? Int {
      likeCount = likes
    } else {
      likeCount = 0
    }
    if let followers = dictionary["followers_count"] as? Int {
      followerCount = followers
    } else {
      followerCount = 0
    }
    if let friends = dictionary["friends_count"] as? Int {
      friendCount = friends
    } else {
      friendCount = 0
    }
    if let tweets = dictionary["statuses_count"] as? Int {
      tweetCount = tweets
    } else {
      tweetCount = 0
    }
    if let description = dictionary["description"] as? String {
      bio = description
    } else {
      bio = ""
    }
    if let loc = dictionary["location"] as? String {
      location = loc
    } else {
      location = ""
    }

    super.init(JSONDictionary: dictionary)!
  }

  required init(coder aDecoder: NSCoder) {
    bio = ""
    location = ""
    likeCount = 0
    followerCount = 0
    friendCount = 0
    tweetCount = 0
    super.init(coder: aDecoder)!
  }

}
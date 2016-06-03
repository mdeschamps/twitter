//
//  Tweet.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation
import TwitterKit

class Tweet: NSObject {

  private static let createdAtFormatter: NSDateFormatter = {
    let fromTwitter = NSDateFormatter()
    fromTwitter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    fromTwitter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return fromTwitter
  }()

  private static let shortDisplayDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yy"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter
  }()

  private static let fullDisplayDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yy hh:mm a"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter
  }()

  let tweetID: String
  let author: User
  let createdAt: NSDate

  let status: String?
  let attributedStatus: NSAttributedString?
  let media: [Media]?

  let retweetedTweet: Tweet?
  var isRetweet: Bool { return retweetedTweet != nil }

  private(set) var retweetCount: Int
  private(set) var likeCount: Int

  private var liked: Bool
  private var retweeted: Bool

  var isLiked: Bool {
    get { return liked }
    set {
      liked = newValue
      if liked {
        likeCount += 1
      } else {
        likeCount = max(0, likeCount-1)
      }
    }
  }

  var isRetweeted: Bool {
    get { return retweeted }
    set {
      retweeted = newValue
      if retweeted {
        retweetCount += 1
      } else {
        retweetCount = max(0, retweetCount-1)
      }
    }
  }

  var shortDisplayCreateAt: String {
    return Tweet.shortDisplayDateFormatter.stringFromDate(createdAt)
  }

  var fullDisplayCreateAt: String {
    return Tweet.fullDisplayDateFormatter.stringFromDate(createdAt)
  }

  required init(JSONDictionary dictionary: [NSObject : AnyObject]) {
    if let ID = dictionary["id_str"] as? String {
      tweetID = ID
    } else {
      tweetID = ""
    }

    (self.status, self.attributedStatus, self.media) = Tweet.attributeTextWithEntities(dictionary)

    if let retweet = dictionary["retweeted_status"] as? [NSObject : AnyObject] {
      retweetedTweet = Tweet(JSONDictionary: retweet)
    } else {
      retweetedTweet = nil
    }

    if let favorited = dictionary["favorited"] as? Bool {
      liked = favorited
    } else {
      liked = false
    }

    if let retweeted = dictionary["retweeted"] as? Bool {
      self.retweeted = retweeted
    } else {
      retweeted = false
    }

    if let user = dictionary["user"] as? [NSObject : AnyObject] {
      author = User(JSONDictionary: user)
    } else {
      author = User(JSONDictionary: [:])
    }

    if let likes = dictionary["favorite_count"] as? Int {
      likeCount = likes
    } else {
      likeCount = 0
    }

    if let retweets = dictionary["retweet_count"] as? Int {
      retweetCount = retweets
    } else {
      retweetCount = 0
    }

    if let timestamp = dictionary["created_at"] as? String,
      date = Tweet.createdAtFormatter.dateFromString(timestamp)
    {
      createdAt = date
    } else {
      createdAt = NSDate()
    }
  }


  private class func attributeTextWithEntities(dictionary: [NSObject : AnyObject]) ->
    (status: String?, attributedString: NSAttributedString?, media: [Media]?){

    if let status = dictionary["text"] as? String {
      let attributedStatus = NSMutableAttributedString(string:status)
      var mediaArray: [Media] = []

      if let entities = dictionary["entities"] as? [String: AnyObject] {
        if let media = entities["media"] as? [[NSObject : AnyObject]] {
          mediaArray = attributeStatusWithMedia(attributedStatus: attributedStatus, media: media)
        }
        if let urls = entities["urls"] as? [[NSObject : AnyObject]] {
          attributeStatusWithUrls(attributedStatus: attributedStatus, urls: urls)
        }
      }
      return (status: status, attributedString: attributedStatus, media: mediaArray)
    }

    return (status: nil, attributedString: nil, media: nil)
  }

  private class func attributeStatusWithMedia(attributedStatus
    attributedStatus: NSMutableAttributedString,
    media: [[NSObject : AnyObject]]) -> [Media]
  {
    var mediaArray: [Media] = []
    let orderedMedia = media.sort({ (mediaJsonA, mediaJsonB) -> Bool in
      let mediaA = Url(JSONDictionary: mediaJsonA)
      let mediaB = Url(JSONDictionary: mediaJsonB)
      if let indicesA = mediaA.indices, indicesB = mediaB.indices {
        return indicesA[0] > indicesB[0]
      }
      return true
    })

    orderedMedia.forEach({ (mediaItem) in
      let media = Media(JSONDictionary: mediaItem)
      if media.type == MediaType.Photo, let indices = media.indices {
        mediaArray.append(media)
        attributedStatus.replaceCharactersInRange(NSRange(location: indices[0], length: indices[1] - indices[0]),
          withString: "")
      }
    })
    return mediaArray
  }

  private class func attributeStatusWithUrls(attributedStatus
    attributedStatus: NSMutableAttributedString,
    urls: [[NSObject : AnyObject]])
  {
    let orderedUrls = urls.sort({ (urlJsonA, urlJsonB) -> Bool in
      let urlA = Url(JSONDictionary: urlJsonA)
      let urlB = Url(JSONDictionary: urlJsonB)
      if let indicesA = urlA.indices, indicesB = urlB.indices {
        return indicesA[0] > indicesB[0]
      }
      return true
    })

    orderedUrls.forEach({ (mediaItem) in
      let url = Url(JSONDictionary: mediaItem)

      if let indices = url.indices, displayUrl = url.displayUrl, fullUrl = url.url {
        let urlDisplay = NSMutableAttributedString(string: displayUrl)
        urlDisplay.addAttribute(NSLinkAttributeName, value: fullUrl, range: NSRange(location: 0, length: displayUrl.characters.count))

        attributedStatus.replaceCharactersInRange(
          NSRange(location: indices[0], length: indices[1] - indices[0]),
          withAttributedString: urlDisplay)
      }
    })
  }
}

extension Tweet {

  class func tweetsWithJSONArray(array: [AnyObject]?) -> [Tweet] {
    var tweets: [Tweet] = []
    if let jsonArr = array as? [[NSObject : AnyObject]] {
      tweets = jsonArr.map({ (tweetDictionary) -> Tweet in
        return Tweet(JSONDictionary: tweetDictionary)
      })
    }
    
    return tweets
  }

}
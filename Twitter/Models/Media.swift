//
//  Media.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

enum MediaType: String {
  case Photo = "photo"
}

class Media: Url {

  var ID: NSNumber?
  var mediaUrl: NSURL?
  var mediaUrlHttps: NSURL?
  var type: MediaType?

  override init(JSONDictionary dictionary: [NSObject : AnyObject]) {
    super.init(JSONDictionary: dictionary)

    if let ID = dictionary["id"] as? NSNumber {
      self.ID = ID
    }
    if let mediaUrl = dictionary["media_url"] as? String {
      self.mediaUrl = NSURL(string: mediaUrl)
    }
    if let mediaUrlHttps = dictionary["media_url_https"] as? String {
      self.mediaUrlHttps = NSURL(string: mediaUrlHttps)
    }
    if let typeStr  = dictionary["type"] as? String, type = MediaType(rawValue: typeStr) {
      self.type = type
    }
  }

}
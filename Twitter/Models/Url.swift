//
//  Url.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

class Url {

  var indices: [Int]?
  var url: NSURL?
  var displayUrl: String?
  var expandedUrl: NSURL?

  init(JSONDictionary dictionary: [NSObject : AnyObject]) {
    if let indices = dictionary["indices"] as? [Int] {
      self.indices = indices
    }
    if let url = dictionary["url"] as? String {
      self.url = NSURL(string: url)
    }
    if let displayUrl = dictionary["display_url"] as? String {
      self.displayUrl = displayUrl
    }
    if let expandedUrl = dictionary["expanded_url"] as? String {
      self.expandedUrl = NSURL(string: expandedUrl)
    }
  }
}
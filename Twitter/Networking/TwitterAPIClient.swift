//
//  TwitterAPIClient.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation
import TwitterKit

enum TweetsResponse {
  case Success(tweets: [Tweet])
  case Failure
}

enum TwitterAPIParams: String {
  case ID = "id"
  case Count = "count"
  case UserID = "user_id"
  case SinceID = "since_id"
  case MaxID = "max_id"
  case Status = "status"
  case InReplyTo = "in_reply_to_status_id"
}

class TwitterAPIClient {

  static var currentUser: User?

  func logOut(completion: () -> Void) {
    if let session = Twitter.sharedInstance().sessionStore.session() {
     Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
    }
    completion()
  }

  internal func fireRequest(method: String = "GET", endpointUrl: NSURL, parameters: [TwitterAPIParams: String]?, completion: (jsonOrNil: AnyObject?) -> (Void)) {
    guard let session = Twitter.sharedInstance().sessionStore.session() else {
      completion(jsonOrNil: nil)
      return
    }

    let client = TWTRAPIClient(userID: session.userID)
    var clientError : NSError?

    var parametersDictionary: [String: AnyObject] = [:]
    parameters?.forEach { (paramName, paramValue) in
      parametersDictionary[paramName.rawValue] = paramValue
    }

    let request = client.URLRequestWithMethod(method, URL: endpointUrl.absoluteString, parameters: parametersDictionary, error: &clientError)

    client.sendTwitterRequest(request) { (response, dataOrNil, connectionError) -> Void in
      if connectionError != nil {
        completion(jsonOrNil: nil)
        return
      }

      guard let data = dataOrNil, json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
      else {
        completion(jsonOrNil: nil)
        return
      }

      completion(jsonOrNil: json)
    }
  }

}
//
//  TwitterAPIClient+User.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/3/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

enum UserResponse {
  case Success(user: User)
  case Failure
}

extension TwitterAPIClient {

  func loadUserWithID(userID userID:String, completion: (response: UserResponse) -> Void) {
    let usersUrl = NSURL(string: "https://api.twitter.com/1.1/users/show.json")!

    let params = [TwitterAPIParams.UserID: userID]

    fireRequest(endpointUrl: usersUrl, parameters: params) { (jsonOrNil) -> Void in
      guard let json = jsonOrNil else {
        completion(response: .Failure)
        return
      }

      if let jsonDictionary = json as? [NSObject : AnyObject] {
        completion(response: .Success(user: User(JSONDictionary: jsonDictionary)))
      } else {
        completion(response: .Failure)
      }
    }
  }

}
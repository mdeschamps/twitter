//
//  AppDelegate.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Fabric.with([Twitter.self])
    
    initializeRootViewController()
    return true
  }

  private func initializeRootViewController() {
    if let session = Twitter.sharedInstance().sessionStore.session() {
      TwitterAPIClient().loadUserWithID(userID: session.userID) { response in
        switch response {
        case .Success(let user):
          TwitterAPIClient.currentUser = user

        case .Failure:
          print("error loading current user")
          Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
          self.initializeLoginFlow()
        }
      }
    } else {
      initializeLoginFlow()
    }
  }

  func initializeLoginFlow() {
    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginVC")
    self.window?.rootViewController = loginVC
  }
}


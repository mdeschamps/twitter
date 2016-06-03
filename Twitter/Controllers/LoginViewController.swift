//
//  LoginViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

  @IBAction func onSignInTapped(sender: AnyObject) {
    Twitter.sharedInstance().logInWithCompletion { (session, error) in
      if let session = session {
        TwitterAPIClient().loadUserWithID(userID: session.userID) { response in
          switch response {
          case .Success(let user):
            TwitterAPIClient.currentUser = user
            if let presentedVC = self.presentedViewController {
              presentedVC.dismissViewControllerAnimated(true) {
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
              }
            } else {
              self.performSegueWithIdentifier("loggedInSegue", sender: self)
            }

          case .Failure:
            let alert = UIAlertController(
              title: "Login failed!",
              message: "Something went wrong, please try again",
              preferredStyle: UIAlertControllerStyle.Alert)

            alert.addAction(UIAlertAction(
              title: "Close",
              style: UIAlertActionStyle.Default,
              handler: nil))

            self.presentViewController(alert, animated: true, completion: nil)
          }
        }
      }
    }
  }

}

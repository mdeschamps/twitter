//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/3/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class ProfileViewController: UserViewController {

  weak var containerDelegate: ContainerViewDelegate?

  private func setupNib() {
    let profileNib = UINib(nibName: "UserViewController", bundle: nil)
    profileNib.instantiateWithOwner(self, options: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNib()
  }

  override func viewDidLoad() {
    user = TwitterAPIClient.currentUser
    super.viewDidLoad()

    actionsWidthConstraint.constant = 30
    
    let logOutImage = UIImage(named: "logout")
    let logOutButton = UIButton(type: .System)
    logOutButton.setImage(logOutImage, forState: .Normal)
    logOutButton.tintColor = UIColor.darkGrayColor()
    logOutButton.frame = CGRect(x: 0, y: 8, width: 20, height: 20)
    logOutButton.addTarget(self, action: #selector(onLogOutTapped), forControlEvents: .TouchDown)

    actionsView.addSubview(logOutButton)
  }

  @objc private func onLogOutTapped(sender: AnyObject) {
    TwitterAPIClient().logOut() { [weak self] in
      guard let weakSelf = self else {
        return
      }
      if let loginVC = weakSelf.storyboard?.instantiateViewControllerWithIdentifier("loginVC") {
        let transition = BounceOutTransition()
        loginVC.transitioningDelegate = transition

        weakSelf.presentViewController(loginVC, animated: true) {
          let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
          delegate.window!.rootViewController = loginVC
          delegate.window!.makeKeyWindow()
        }
      }
    }
  }

  @IBAction func onMenuTapped(sender: AnyObject) {
    containerDelegate?.toggleSideBar()
  }

  @IBAction func onComposeTapped(sender: AnyObject) {
    let composeVC = ComposeViewController()
    composeVC.delegate = self

    presentViewController(composeVC, animated: true, completion: nil)
  }
}

extension ProfileViewController: ComposeDelegate {
  func didTweetSend(tweet: Tweet) {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    tweetsTableView.addTweet(tweet)
  }

  func didTweetCancel() {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
//
//  SideBarViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

enum SideBarTab {
  case Home
  case Mentions
  case Profile
}

protocol SideBarDelegate: class {
  func onSideBarTabChange(tab: SideBarTab)
}

class SideBarViewController: UIViewController {

  @IBOutlet weak var homeButton: UIButton!
  @IBOutlet weak var mentionsButton: UIButton!
  @IBOutlet weak var profileButton: UIButton!

  weak var delegate: SideBarDelegate?

  var activeTab: SideBarTab = .Home {
    didSet {
      highlightActiveTab()
      delegate?.onSideBarTabChange(activeTab)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    highlightActiveTab()
  }

  @IBAction func onMentionsTapped(sender: AnyObject) {
    activeTab = .Mentions
  }

  @IBAction func onHomeTapped(sender: AnyObject) {
    activeTab = .Home
  }

  @IBAction func onProfileTapped(sender: AnyObject) {
    activeTab = .Profile
  }

  private func highlightActiveTab(){
    homeButton.tintColor = UIColor.lightGrayColor()
    mentionsButton.tintColor = UIColor.lightGrayColor()
    profileButton.tintColor = UIColor.lightGrayColor()

    switch activeTab {
    case .Home:
      homeButton.tintColor = UIColor.whiteColor()
    case .Mentions:
      mentionsButton.tintColor = UIColor.whiteColor()
    case .Profile:
      profileButton.tintColor = UIColor.whiteColor()
    }
  }
}

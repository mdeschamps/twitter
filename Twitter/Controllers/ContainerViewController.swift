//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

protocol ContainerViewDelegate: class {
  func toggleSideBar()
}

class ContainerViewController: UIViewController {

  @IBOutlet weak var sideBarView: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!

  weak var homeNavigationController: UINavigationController?
  weak var mentionsNavigationController: UINavigationController?
  weak var profileNavigationController: UINavigationController?

  var isSideBarOpened = false

  override func viewDidLoad() {
    super.viewDidLoad()

    closeSideBar(force: true)

    containerView.layer.shadowColor = UIColor.blackColor().CGColor
    containerView.layer.shadowOpacity = 0.7
    containerView.layer.shadowRadius = 6
    containerView.layer.shadowOffset = CGSize(width: -6, height: 0)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.destinationViewController {

    case let navigationController as UINavigationController:
      homeNavigationController = navigationController
      if let homeVC = homeNavigationController?.topViewController as? HomeTimelineViewController {
        homeVC.containerDelegate = self
      }

    case let sideBarVC as SideBarViewController:
      sideBarVC.delegate = self

    default: break;
    }
  }

  @IBAction func onContainerLeftSwiped(recognizer: UIGestureRecognizer) {
    if recognizer.state == .Ended {
      openSideBar()
    }
  }

  @IBAction func onContainerRightSwiped(recognizer: UISwipeGestureRecognizer) {
    if recognizer.state == .Ended  {
      closeSideBar()
    }
  }

  private func closeSideBar(force force:Bool = false){
    if !force && !self.isSideBarOpened {
      return
    }

    view.layoutIfNeeded()
    containerLeadingConstraint.constant = 0
    containerTrailingConstraint.constant = 0
    self.isSideBarOpened = false

    if !force {
      UIView.animateWithDuration(0.3, delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: [.CurveEaseIn],
        animations:
      {
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
  }

  private func openSideBar(){
    if self.isSideBarOpened {
      return
    }

    view.layoutIfNeeded()
    containerLeadingConstraint.constant = sideBarView.frame.width
    containerTrailingConstraint.constant = -sideBarView.frame.width
    self.isSideBarOpened = true

    UIView.animateWithDuration(0.3, delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: [.CurveEaseOut],
      animations:
    {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

extension ContainerViewController: ContainerViewDelegate {
  func toggleSideBar() {
    if self.isSideBarOpened {
      closeSideBar()
    } else {
      openSideBar()
    }
  }
}

extension ContainerViewController: SideBarDelegate {

  private func instantiateNewContainerNavigationController(storyboardIdentifier: String) -> UINavigationController? {
    if let navigationController = storyboard?.instantiateViewControllerWithIdentifier(storyboardIdentifier) as? UINavigationController {
      addChildViewController(navigationController)
      navigationController.didMoveToParentViewController(self)
      return navigationController
    }
    return nil
  }

  private func replaceContainerView(navigationController: UINavigationController?) {
    if let navigationController = navigationController {
      for subview in containerView.subviews {
        subview.removeFromSuperview()
      }
      navigationController.view.frame.size = containerView.frame.size
      containerView.addSubview(navigationController.view)
    }
  }

  func onSideBarTabChange(tab: SideBarTab) {
    switch tab {

    case .Home:
      replaceContainerView(homeNavigationController)

    case .Mentions:
      let mentionsNavigationController: UINavigationController? = self.mentionsNavigationController ?? {
        self.mentionsNavigationController = instantiateNewContainerNavigationController("mentionsNVC")
        return self.mentionsNavigationController
      }()

      if let mentionsVC = mentionsNavigationController?.topViewController as? MentionsViewController {
        mentionsVC.containerDelegate = self
      }

      replaceContainerView(mentionsNavigationController)

    case .Profile:
      let profileNavigationController: UINavigationController? = self.profileNavigationController ?? {
        self.profileNavigationController = instantiateNewContainerNavigationController("profileNVC")
        return self.profileNavigationController
      }()

      if let profileVC = profileNavigationController?.topViewController as? ProfileViewController {
        profileVC.containerDelegate = self
      }

      replaceContainerView(profileNavigationController)
    }

    closeSideBar()
  }
}


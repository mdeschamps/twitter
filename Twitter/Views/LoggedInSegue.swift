//
//  LoggedInSegue.swift
//  Twitter
//
//  Created by Manuel Deschamps on 5/31/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class LoggedInSegue: UIStoryboardSegue {

  override func perform() {
    let sourceView = sourceViewController.view
    let destinationView = destinationViewController.view

    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    destinationView.frame = CGRect(x: 0, y: -screenHeight, width: screenWidth, height: screenHeight)

    let window = UIApplication.sharedApplication().keyWindow
    window?.insertSubview(destinationView, aboveSubview: sourceView)

    UIView.animateWithDuration(0.4, animations: {
      sourceView.frame = CGRectOffset(sourceView.frame, 0, screenHeight)
      destinationView.frame = CGRectOffset(destinationView.frame, 0, screenHeight)

    }) { (finished) in
      self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
    }
  }

}

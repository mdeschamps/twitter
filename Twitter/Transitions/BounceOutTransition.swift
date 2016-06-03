//
//  BounceOutTransition.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/3/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class BounceOutTransition: NSObject, UIViewControllerTransitioningDelegate {

  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
}

extension BounceOutTransition: UIViewControllerAnimatedTransitioning {

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 1.0
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView()!
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!

    let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
    let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)

    toView.transform = offScreenRight

    container.addSubview(toView)
    container.addSubview(fromView)

    let duration = self.transitionDuration(transitionContext)
    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
      fromView.transform = offScreenLeft
      toView.transform = CGAffineTransformIdentity
    }, completion: { finished in
      transitionContext.completeTransition(true)
    })
  }
}
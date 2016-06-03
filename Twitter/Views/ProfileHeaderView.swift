//
//  ProfileHeaderView.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class ProfileHeaderView: UIView {

  @IBOutlet var view: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var profileInfo: UIView!
  @IBOutlet weak var profileBio: UIView!

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var locationBio: UILabel!

  weak var user: User? {
    didSet {
      guard let user = self.user else {
        return
      }

      nameLabel.text = user.name
      screenNameLabel.text = user.formattedScreenName
      if let url = NSURL(string:user.profileImageLargeURL) {
        avatarImage.af_setImageWithURL(url)
      } else {
        avatarImage.image = nil
      }
      bioLabel.text = user.bio
      locationBio.text = user.location
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    let nib = UINib(nibName: String(self.dynamicType), bundle: nil)
    if nib.instantiateWithOwner(self, options: nil) is [UIView] {
      scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
      scrollView.translatesAutoresizingMaskIntoConstraints = true
      scrollView.delegate = self
      
      profileInfo.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
      profileInfo.translatesAutoresizingMaskIntoConstraints = true

      profileBio.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
      profileBio.translatesAutoresizingMaskIntoConstraints = true

      scrollView.addSubview(profileInfo)
      scrollView.addSubview(profileBio)

      pageControl.currentPage = 0

      addSubview(view)
    }
  }

  override func layoutSubviews() {
    scrollView.frame = bounds

    profileInfo.frame = bounds
    profileInfo.frame.origin.x = 0

    profileBio.frame = bounds
    profileBio.frame.origin.x = bounds.size.width

    scrollView.contentSize = CGSizeMake(bounds.size.width*2, bounds.size.height)
  }
}

extension ProfileHeaderView: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.x / frame.width)
    pageControl.currentPage = page
  }
}

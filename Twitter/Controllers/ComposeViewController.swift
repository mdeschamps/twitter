//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/2/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit
import TwitterKit

protocol ComposeDelegate: class {
  func didTweetSend(tweet: Tweet)
  func didTweetCancel()
}

class ComposeViewController: UIViewController {

  private static let TweetLength = 140

  @IBOutlet weak var charCountLabel: UILabel!
  @IBOutlet weak var tweetInput: UITextView!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetButton: UIBarButtonItem!

  weak var delegate: ComposeDelegate?

  var inReplyToTweet: Tweet?

  var statusText: String {
    return tweetInput.text.stringByTrimmingCharactersInSet(
      NSCharacterSet.whitespaceAndNewlineCharacterSet()
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tweetInput.delegate = self
    if let tweet = inReplyToTweet {
      tweetInput.text = tweet.author.formattedScreenName + " "
    } else {
      tweetInput.text = ""
    }
    
    self.nameLabel.text = ""
    self.screenNameLabel.text = ""
    self.avatarImage.image = nil

    if let user = TwitterAPIClient.currentUser {
      self.nameLabel.text = user.name
      self.screenNameLabel.text = user.formattedScreenName
      if let url = NSURL(string:user.profileImageLargeURL) {
        self.avatarImage.af_setImageWithURL(url)
      }
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    tweetInput.becomeFirstResponder()
  }

  @IBAction func onCancelTapped(sender: AnyObject) {
    delegate?.didTweetCancel()
  }

  @IBAction func onTweetTapped(sender: AnyObject) {
    tweetButton.enabled = false
    if remainingCount() < 0 {
      return
    }

    tweetInput.resignFirstResponder()

    TwitterAPIClient().tweetStatus(status: statusText, inReplyToTweetID: inReplyToTweet?.tweetID ?? nil) { response in
      switch response {

      case .Success(let tweet):
        self.delegate?.didTweetSend(tweet)

      case .Failure:
        self.tweetButton.enabled = true

        let alert = UIAlertController(
          title: "Tweet failed!",
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

  private func remainingCount() -> Int {
    return ComposeViewController.TweetLength - statusText.characters.count
  }

  private func updateCharCounter(){
    let remainingChars = remainingCount()
    charCountLabel.text = String(remainingChars)
    charCountLabel.textColor = UIColor.blackColor()

    switch remainingChars {
    case 0...20:
      tweetButton.enabled = true
      charCountLabel.textColor = UIColor.darkGrayColor()
    case -1 ..< -1:
      tweetButton.enabled = false
      charCountLabel.textColor = UIColor.redColor()
    default:
      tweetButton.enabled = true
      charCountLabel.textColor = UIColor.lightGrayColor()
    }
  }
}

extension ComposeViewController: UITextViewDelegate {
  func textViewDidBeginEditing(textView: UITextView) {
    updateCharCounter()
  }

  func textViewDidEndEditing(textView: UITextView) {
    updateCharCounter()
  }

  func textViewDidChange(textView: UITextView) {
    updateCharCounter()
  }
}
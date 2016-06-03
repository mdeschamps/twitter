//
//  NSDate+Deltas.swift
//  Twitter
//
//  Created by Manuel Deschamps on 6/1/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import Foundation

extension NSDate {
  func daysFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
  }
  func hoursFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
  }
  func minutesFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
  }
  func secondsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
  }
  func offsetFrom(date:NSDate) -> String? {
    let days = daysFrom(date)
    if days > 7 { return nil }
    if days > 0 { return "\(daysFrom(date))d"    }
    if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
    if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
    if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
    return nil
  }
}
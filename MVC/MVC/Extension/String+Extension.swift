//
//  String+Extension.swift
//  MVC
//
//  Created by hy_sean on 19/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

extension String {
  var dateFormat: String {
    
    let dateString = self
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //this your string date format
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let convertedDate = dateFormatter.date(from: dateString)
    
    guard dateFormatter.date(from: dateString) != nil else {
      assert(false, "no date from string")
      return ""
    }
    
    dateFormatter.dateFormat = "MMM d, h:mm a" //this is what you want to convert format
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let timeStamp = dateFormatter.string(from: convertedDate!)
    
    return timeStamp
  }
}

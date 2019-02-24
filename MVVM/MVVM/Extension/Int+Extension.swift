//
//  Int+Extension.swift
//  MVC
//
//  Created by hy_sean on 19/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

extension Int {
	var abbreviated: String {
		
		guard self >= 1000 else { return "\(self)" }
		
		let suffixList = ["", "k", "m", "b", "t", "p", "e"]
		var index: Int = 0
		var value = Double(self)
		
		while (value / 1000) >= 1 {
			value = value / 1000
			index += 1
		}
		
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 1
		let formatString = formatter.string(for: value)
		
		return String(format: "%@%@", formatString ?? "0", suffixList[index])
	}
}

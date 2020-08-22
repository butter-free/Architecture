//
//  Box.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/21.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

// https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc
final class Box<T> {
	
	typealias Listener = (T) -> Void
	var listener: Listener?
	
	var value: T {
		didSet {
			listener?(value)
		}
	}
  
	init(_ value: T) {
		self.value = value
	}
  
	func bind(listener: Listener?) {
		self.listener = listener
		listener?(value)
	}
}

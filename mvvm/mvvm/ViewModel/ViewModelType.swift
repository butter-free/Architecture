//
//  ViewModelType.swift
//  mvvm
//
//  Created by sean on 2020/08/25.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

protocol ViewModelType {
	associatedtype Action
	associatedtype State
	
	func binding()
}

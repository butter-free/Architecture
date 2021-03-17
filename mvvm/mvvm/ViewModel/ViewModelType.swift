//
//  ViewModelType.swift
//  mvvm
//
//  Created by sean on 2020/08/25.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

protocol ViewModelType {
	func binding()
	
	var networkService: NetworkService { get }
}

extension ViewModelType {
	var networkService: NetworkService {
		return NetworkManager.shared
	}
}

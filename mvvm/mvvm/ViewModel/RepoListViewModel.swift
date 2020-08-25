//
//  RepoListViewModel.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/22.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation
import UIKit

class RepoListViewModel: ViewModelType {
	
	let userID: String
	let repoList: [Repo]!
	
	init(userID: String, repoList: [Repo]) {
		self.userID = userID
		self.repoList = repoList
	}
	
	func binding() {
		
	}
}

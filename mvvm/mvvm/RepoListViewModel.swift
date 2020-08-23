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
	
	func tableViewHeightForRowAt(indexPath: IndexPath) -> CGFloat {
		let repo = repoList[indexPath.row]
		
		if let _ = repo.description, let _ = repo.language {
			return 120
		}
		
		if repo.description != nil || repo.language != nil {
			return 90
		} else {
			return 60
		}
	}
}

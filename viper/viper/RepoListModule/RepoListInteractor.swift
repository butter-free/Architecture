//
//  RepoListInteractor.swift
//  viper
//
//  Created by hy_sean on 2020/10/19.
//

import Foundation

class RepoListInteractor {
	
	let userID: String
	let repoList: [Repo]
	
	init(userID: String, repoList: [Repo]) {
		self.userID = userID
		self.repoList = repoList
	}
}

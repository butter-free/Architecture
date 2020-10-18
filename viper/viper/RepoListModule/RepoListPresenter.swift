//
//  RepoListPresenter.swift
//  viper
//
//  Created by hy_sean on 2020/10/19.
//

import Foundation

class RepoListPresenter: NSObject {
	
	var userID: String {
		return interactor.userID
	}
	
	var repoList: [Repo] {
		return interactor.repoList
	}
	
	let interactor: RepoListInteractor
	
	init(interactor: RepoListInteractor) {
		self.interactor = interactor
	}
}

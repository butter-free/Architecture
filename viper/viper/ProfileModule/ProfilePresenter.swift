//
//  ProfilePresenter.swift
//  viper
//
//  Created by hy_sean on 2020/10/17.
//

import UIKit

class ProfilePresenter: NSObject {
	
	var avatarURL: Box<String> {
		return interactor.avatarURL
	}
	
	private var userID: String = ""
	private let router = ProfileRouter()
	
	let interactor: ProfileInteractor
	
	init(interactor: ProfileInteractor) {
		self.interactor = interactor
	}
	
	func setUserID(_ id: String) {
		self.userID = id
		interactor.userID.value = id
	}
	
	func builder() -> UIViewController {
		return router.repoListViewController(
			userID: userID,
			repoList: interactor.repoList
		)
	}
}

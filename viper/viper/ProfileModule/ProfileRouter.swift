//
//  ProfileRouter.swift
//  viper
//
//  Created by hy_sean on 2020/10/17.
//

import UIKit

class ProfileRouter {
	func repoListViewController(userID: String, repoList: [Repo]) -> UIViewController {
		let presenter = RepoListPresenter(
			interactor: RepoListInteractor(userID: userID, repoList: repoList)
		)
		return RepoListViewController(presenter: presenter)
	}
}

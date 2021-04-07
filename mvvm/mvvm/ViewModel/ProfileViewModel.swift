//
//  ProfileViewModel.swift
//  mvvm
//
//  Created by sean on 2020/08/21.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

final class ProfileViewModel: ViewModelType {
	
	typealias ProfileItems = (userID: String, repoList: [Repo])
	
	// Action
	struct Action {
		var presentRepoList = Box<Void>(())
		var inputUserID = Box<String>("")
	}
	
	// State
	struct State {
		var avatarURL = Box<String>("")
		var items = Box<ProfileItems>(("", []))
	}
	
	var action = Action()
	var state = State()
	
	private var userID = ""
	private var repoList: [Repo] = []
	
	let reposRepository: ReposRepository
	
	init(reposRepository: ReposRepository) {
		self.reposRepository = reposRepository
		
		action.inputUserID
			.bind { [weak self] id in
				guard let `self` = self else { return }
				
				if id.isEmpty {
					self.state.avatarURL.value = ""
					return
				}
				
				self.userID = id
				
				reposRepository.requestRepos(id: id) { repos in
					// fork한 repo 제외
					self.repoList = repos.filter { !$0.fork }
					
					guard let avatarURL = repos.first?.owner.avatarURL else {
						self.state.avatarURL.value = ""
						return
					}
					
					self.state.avatarURL.value = avatarURL
				}
			}
		
		action.presentRepoList
			.bind { [weak self] in
				guard let `self` = self else {
					fatalError("Unexpectedly found nil")
				}
				
				self.state.items.value = (userID: self.userID, repoList: self.repoList)
			}
	}
}

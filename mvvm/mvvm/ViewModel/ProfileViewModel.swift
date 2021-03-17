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
	
	init() {
		binding()
	}
	
	func binding() {
		
		action.inputUserID.bind { [weak self] id in
			
			guard let `self` = self else { return }
			
			if id.isEmpty {
				self.state.avatarURL.value = ""
				return
			}
			
			self.userID = id
			
			NetworkManager.shared.request(
				url: "https://api.github.com/users/\(id)/repos"
			) { (result: Result<[Repo], Error>) in
				switch result {
				case let .success(data):
					// fork한 repo 제외
					self.repoList = data.filter { !$0.fork }
					
					guard let avatarURL = data.first?.owner.avatarURL else {
						self.state.avatarURL.value = ""
						return
					}
					
					self.state.avatarURL.value = avatarURL
				case let .failure(error):
					self.state.avatarURL.value = ""
					print(error)
				}
			}
		}
		
		action.presentRepoList.bind { [weak self] in
			guard let `self` = self else {
				fatalError("Unexpectedly found nil")
			}
			
			self.state.items.value = (userID: self.userID, repoList: self.repoList)
		}
	}
}

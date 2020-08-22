//
//  ProfileViewModel.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/21.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

protocol ViewModelType {
	func binding()
}

class ProfileViewModel: ViewModelType {
	
	var repoList: [Repo] = []
	
	var userID: Box<String> = Box<String>("")
	var avatarURL: Box<String> = Box<String>("")
	
	let networkService: NetworkService!
	
	init(networkService: NetworkService) {
		self.networkService = networkService
		binding()
	}
	
	func binding() {
		
		userID.bind { [weak self] id in
			
			guard let `self` = self, !id.isEmpty else { return }
			
			self.networkService.request(
				url: "https://api.github.com/users/\(id)/repos",
				model: [Repo].self
			) { result in
				switch result {
				case let .success(data):
					// fork한 repo 제외
					self.repoList = data.filter { !$0.fork }
					
					guard let avatarURL = data.first?.owner.avatarURL else {
						self.avatarURL.value = ""
						return
					}
					
					self.avatarURL.value = avatarURL
				case let .failure(error):
					self.avatarURL.value = ""
					print(error)
				}
			}
		}
	}
}

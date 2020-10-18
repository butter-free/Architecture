//
//  ProfileInteractor.swift
//  viper
//
//  Created by hy_sean on 2020/10/17.
//

import Foundation

class ProfileInteractor {
	
	var repoList: [Repo] = []
	
	var userID: Box<String> = Box<String>("")
	var avatarURL: Box<String> = Box<String>("")
	
	let networkService: NetworkService
	
	init(networkService: NetworkService) {
		self.networkService = networkService
		binding()
	}
	
	private func binding() {
		
		userID.bind { [weak self] id in
			
			guard let `self` = self else { return }
			
			if id.isEmpty {
				self.avatarURL.value = ""
				return
			}
			
			self.networkService.request(
				url: "https://api.github.com/users/\(id)/repos"
			) { (result: Result<[Repo], Error>) in
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

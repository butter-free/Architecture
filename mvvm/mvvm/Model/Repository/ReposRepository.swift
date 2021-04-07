//
//  ReposRepository.swift
//  mvvm
//
//  Created by sean on 2021/04/07.
//  Copyright © 2021 siwon. All rights reserved.
//

import Foundation

protocol ReposRepository {
	func requestRepos(id: String, handler: @escaping ([Repo]) -> Void)
}

class ReposDataRepository: ReposRepository {
	
	let networkService: NetworkService
	
	init(networkService: NetworkService) {
		self.networkService = networkService
	}
}

extension ReposDataRepository {
	func requestRepos(id: String, handler: @escaping ([Repo]) -> Void) {
		networkService.request(
			url: "https://api.github.com/users/\(id)/repos"
		) { (result: Result<[Repo], Error>) in
			switch result {
			case let .success(data):
				handler(data)
			case let .failure(error):
				handler([])
				print(error)
			}
		}
	}
}

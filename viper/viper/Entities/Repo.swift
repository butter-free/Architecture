//
//  Repo.swift
//  viper
//
//  Created by hy_sean on 2020/10/17.
//

import Foundation

// MARK: - Repo
struct Repo: Codable {
		let name: String
		let owner: Owner
		let htmlURL: String?
		let description: String?
		let fork: Bool
		let url: String?
		let language: String?
	
	let updatedDate: String

		enum CodingKeys: String, CodingKey {
				case name
				case owner
				case htmlURL = "html_url"
				case description
				case fork, url, language
		case updatedDate = "updated_at"
		}
}

// MARK: - Owner
struct Owner: Codable {
		let avatarURL: String

		enum CodingKeys: String, CodingKey {
				case avatarURL = "avatar_url"
		}
}

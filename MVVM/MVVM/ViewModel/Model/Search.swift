//
//  Search.swift
//  MVVM
//
//  Created by hy_sean on 17/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

struct Search: Codable {
	var totalCount: Int?
	var items: [Item]?
	
	init() {
		totalCount = 0
		items = []
	}
	
	enum CodingKeys: String, CodingKey {
		case totalCount = "total_count"
		case items
	}
}

struct Item: Codable {
	var fullName: String?
	var owner: Owner?
	var star: Int?
	var language: String?
	var updatedDate: String?
	var htmlUrl: String?
	
	enum CodingKeys: String, CodingKey {
		case fullName = "full_name"
		case owner
		case star = "stargazers_count"
		case language
		case updatedDate = "updated_at"
		case htmlUrl = "html_url"
	}
}

struct Owner: Codable {
	var avatarUrl: String?
	
	enum CodingKeys: String, CodingKey {
		case avatarUrl = "avatar_url"
	}
}

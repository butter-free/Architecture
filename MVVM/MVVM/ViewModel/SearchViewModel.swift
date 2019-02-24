//
//  SearchViewModel.swift
//  MVVM
//
//  Created by hy_sean on 24/02/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

struct SearchViewModel {
	private var searchViewModel: Search? = Search()
	
	mutating func setSearchModel(_ search: Search?) {
		searchViewModel = search
	}
	
	func numberOfItems() -> Int {
		return searchViewModel?.items?.count ?? 0
	}
	
	func getItem(at index: Int) -> Item? {
		return searchViewModel?.items?[index]
	}
}

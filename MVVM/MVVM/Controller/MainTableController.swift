//
//  ViewController.swift
//  MVC
//
//  Created by hy_sean on 11/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import UIKit
import SafariServices

class MainTableController: UITableViewController {
	
	enum Height {
		static let cell: CGFloat = 84
		static let navigationBar: CGFloat = 84
	}
	
	let activityView = UIActivityIndicatorView(style: .gray)
	
	let searchController = UISearchController(searchResultsController: nil)
	var safariController: SFSafariViewController?
	
	var searchViewModel: SearchViewModel = SearchViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		definesPresentationContext = true
		setupSearchBar()
	}
	
	fileprivate func setupSearchBar() {
		navigationItem.title = "Github Search"
		
		searchController.searchBar.placeholder = "Search Repo.."
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	// MARK:- UITableView Datasource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchViewModel.numberOfItems()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		let cell = MainTableViewCell(style: .default, reuseIdentifier: nil)
		cell.setupCell(searchViewModel, index)
		return cell
	}
	
	// MARK:- UITableView Delegate
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Height.cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		
		tableView.deselectRow(at: indexPath, animated: false)
		
		guard let stringUrl = searchViewModel.getItem(at: index)?.htmlUrl else { return }
		guard let url = URL(string: stringUrl) else { return }
		safariController = SFSafariViewController(url: url)
		
		guard let safari = safariController else { return }
		safari.delegate = self
		searchController.present(safari, animated: true, completion: nil)
	}
}

extension MainTableController: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		safariController = nil
	}
}

extension MainTableController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			searchViewModel.setSearchModel(nil)
			tableView.reloadData()
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else { return }
		requestSearch(searchText, tryErrorOccurs: 3)
	}
	
	fileprivate func requestSearch(_ searchText: String, tryErrorOccurs: Int) {
		startActivity()
		Request.search(searchText) { [weak self] (data, error) in
			self?.stopActivity()
			
			if let error = error {
				print("searchError => \(error)")
				if tryErrorOccurs > 0 {
					self?.requestSearch(searchText, tryErrorOccurs: tryErrorOccurs - 1)
				}
				return
			}
			
			guard let data = data else { return }
			self?.searchViewModel.setSearchModel(data)
			self?.tableView.reloadData()
		}
	}
	
	fileprivate func startActivity() {
		activityView.center = CGPoint(x: view.center.x, y: view.center.y - Height.navigationBar)
		view.addSubview(activityView)
		activityView.startAnimating()
	}
	
	fileprivate func stopActivity() {
		activityView.stopAnimating()
		activityView.removeFromSuperview()
	}
}

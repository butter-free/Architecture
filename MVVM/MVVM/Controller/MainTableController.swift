//
//  ViewController.swift
//  MVC
//
//  Created by hy_sean on 11/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class MainTableController: UITableViewController {
	
	enum Height {
		static let navigationBar: CGFloat = 84
	}
	
	let activityView = UIActivityIndicatorView(style: .gray)
	
	let searchController = UISearchController(searchResultsController: nil)
	var safariController: SFSafariViewController?
	
	var searchViewModel: SearchViewModel = SearchViewModel()
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		definesPresentationContext = true
		setupSearchBar()
		setupTableView()
	}
	
	fileprivate func setupSearchBar() {
		navigationItem.title = "Github Search"
		
		searchController.searchBar.placeholder = "Search Repo.."
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		
		searchController.searchBar.rx.text
			.throttle(0.3, scheduler: MainScheduler.instance)
			.subscribe(
				onNext: { [weak self] query in
					guard let query = query else { return }
					self?.requestSearch(query)
				}
			)
			.disposed(by: disposeBag)
	}
	
	fileprivate func setupTableView() {
		
		tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
		
		tableView.rx.itemSelected
			.subscribe(
				onNext: { [weak self] indexPath in
					guard let `self` = self else { return }
					let index = indexPath.row
					
					self.tableView.deselectRow(at: indexPath, animated: false)
					guard let stringUrl = self.searchViewModel.getItem(at: index)?.htmlUrl else { return }
					self.openSafariView(with: stringUrl)
				}
			)
			.disposed(by: disposeBag)
	}
	
	fileprivate func openSafariView(with url: String) {
		guard let url = URL(string: url) else { return }
		safariController = SFSafariViewController(url: url)
		
		guard let safari = safariController else { return }
		safari.delegate = self
		searchController.present(safari, animated: true, completion: nil)
	}
	
	fileprivate func requestSearch(_ searchText: String) {
		startActivity()
		Request.search(searchText) { [weak self] (data, error) in
			guard let `self` = self else { return }
			self.stopActivity()
			
			if let error = error {
				print("searchError => \(error)")
				return
			}
			
			guard let data = data else { return }
			self.searchViewModel.setSearchModel(data)
			
			self.tableView.dataSource = nil
			self.tableView.delegate = nil
			
			Observable.from(optional: self.searchViewModel.getItems())
				.bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: MainTableViewCell.self)) { (row, item, cell) in
					cell.setupCell(item)
				}.disposed(by: self.disposeBag)
			
			self.tableView.reloadData()
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
}

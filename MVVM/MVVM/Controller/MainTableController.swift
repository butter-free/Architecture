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

/*
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
*/

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
  }
  
  let searchController = UISearchController(searchResultsController: nil)
  
  lazy var searchBar: UISearchBar = {
    let search = UISearchBar()
    search.barStyle = .default
    return search
  }()
  
  var searchData: Search?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
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
    return searchData?.items?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let index = indexPath.row
    let item = searchData?.items?[index]
    
    let cell = MainTableViewCell(style: .default, reuseIdentifier: nil)
    
    if let imageUrl = item?.owner?.avatarUrl {
      
      URLSession.shared.request(urlString: imageUrl) { (data, res, error) in
        
        guard let data = data else { return }
        
        cell.avatarView.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
      }
    }
    
    cell.repoTitleLabel.text = item?.fullName
    cell.languageLabel.text = item?.language
    cell.starsLabel.text = "\(String(item?.star?.abbreviated ?? "0")) Stars"
    
    if let updatedDate = item?.updatedDate {
      cell.updateDateLabel.text = "updated \(updatedDate.dateFormat)"
    }
    
    return cell
  }
  
  // MARK:- UITableView Delegate
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Height.cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    
    tableView.deselectRow(at: indexPath, animated: false)
    
    guard let htmlUrl = searchData?.items?[index].owner?.htmlUrl else { return }
    guard let url = URL(string: htmlUrl) else { return }
    let safariController = SFSafariViewController(url: url)
    searchController.present(safariController, animated: true, completion: nil)
  }
}

extension MainTableController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      searchData = nil
      tableView.reloadData()
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    
    Request.search(searchText) { (data, error) in
      if let error = error {
        print("searchError => \(error)")
        return
      }
      
      guard let data = data else { return }
      
      self.searchData = data
      self.tableView.reloadData()
    }
  }
}

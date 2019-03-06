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

class MainController: UITableViewController {
  
  enum Height {
    static let navigationBar: CGFloat = 84
  }
  
  let activityView = UIActivityIndicatorView(style: .gray)
  
  let searchController = UISearchController(searchResultsController: nil)
  var safariController: SFSafariViewController?
  
  var searchList: [Item]? = [Item]()
  
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    definesPresentationContext = true
    tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
    setupSearchBar()
    
    tableView.rx.itemSelected
      .subscribe(
        onNext: { [weak self] indexPath in
          guard let `self` = self else { return }
          let index = indexPath.row
          
          self.tableView.deselectRow(at: indexPath, animated: false)
          guard let stringUrl = self.searchList?[index].htmlUrl else { return }
          self.openSafariView(with: stringUrl)
        }
      )
      .disposed(by: disposeBag)
  }
  
  fileprivate func setupSearchBar() {
    navigationItem.title = "Github Search"
    
    searchController.searchBar.placeholder = "Search Repo.."
    searchController.obscuresBackgroundDuringPresentation = false
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    searchController.searchBar.rx.text
      .throttle(0.3, scheduler: MainScheduler.instance)
      .subscribe(
        onNext: { [weak self] query in
          guard let `self` = self else { return }
          guard let query = query else { return }
          print(query)
          if query.isEmpty {
            self.searchList = nil
            self.tableView.reloadData()
            return
          }
          self.requestSearch(query)
        }
      ).disposed(by: disposeBag)
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
      self.tableView.delegate = nil
      self.tableView.dataSource = nil
      
      self.searchList = data?.items
      
      Observable.from(optional: self.searchList)
        .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: MainTableViewCell.self)) { (row, item, cell) in
          
          if let imageUrl = item.owner?.avatarUrl {
            URLSession.shared.request(urlString: imageUrl) { [weak cell] (data, res, error) in
              guard let data = data else { return }
              cell?.avatarView.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
            }
          }
          
          cell.repoTitleLabel.text = item.fullName
          cell.languageLabel.text = "\(item.language ?? "Not Found Language")"
          cell.starsLabel.text = "\(String(item.star?.abbreviated ?? "0")) Stars"
          
          if let updatedDate = item.updatedDate {
            cell.updateDateLabel.text = "updated \(updatedDate.dateFormat)"
          }
          
          self.tableView.reloadData()
        }.disposed(by: self.disposeBag)
    }
  }
  
  fileprivate func openSafariView(with url: String) {
    guard let url = URL(string: url) else { return }
    self.safariController = SFSafariViewController(url: url)
    
    guard let safari = self.safariController else { return }
    safari.delegate = self
    self.searchController.present(safari, animated: true, completion: nil)
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

extension MainController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    safariController = nil
  }
}

//
//  RepoListController.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/22.
//  Copyright © 2020 siwon. All rights reserved.
//

import UIKit
import SafariServices

class RepoListController: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.identifier)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		return tableView
	}()
	
	let viewModel: RepoListViewModel!
	
	init(viewModel: RepoListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
	}
	
	func configureUI() {
		view.backgroundColor = .white
		
		navigationItem.title = "\(viewModel.userID)'s repositories"
		
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
}

extension RepoListController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.repoList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath) as! RepoCell
		cell.configure(repo: viewModel.repoList[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		viewModel.tableViewHeightForRowAt(indexPath: indexPath)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		let htmlURL = viewModel.repoList[indexPath.row].htmlURL ?? ""
		print(htmlURL)
		
		guard let url = URL(string: htmlURL) else { return }
		
		let safari = SFSafariViewController(url: url)
		safari.modalPresentationStyle = .popover
		
		present(safari, animated: true)
	}
}

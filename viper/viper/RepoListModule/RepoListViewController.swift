//
//  RepoListViewController.swift
//  viper
//
//  Created by hy_sean on 2020/10/19.
//

import SafariServices
import UIKit

final class RepoListViewController: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.identifier)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		return tableView
	}()
	
	let presenter: RepoListPresenter
	
	init(presenter: RepoListPresenter) {
		self.presenter = presenter
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
		
		navigationItem.title = "\(presenter.userID)'s repositories"
		
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
}

extension RepoListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.repoList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath) as! RepoCell
		cell.configure(repo: presenter.repoList[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		let htmlURL = presenter.repoList[indexPath.row].htmlURL ?? ""
		print(htmlURL)
		
		guard let url = URL(string: htmlURL) else { return }
		
		let safari = SFSafariViewController(url: url)
		safari.modalPresentationStyle = .popover
		
		present(safari, animated: true)
	}
}

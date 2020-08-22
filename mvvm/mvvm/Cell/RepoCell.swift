//
//  RepoCell.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/23.
//  Copyright © 2020 siwon. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
	
	static let identifier = "RepoCell"
	
	lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 8
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		return stackView
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .black
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	lazy var horizontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		return stackView
	}()
	
	lazy var hashTagImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "number")?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
		return imageView
	}()
	
	lazy var languageLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		titleLabel.text = ""
		descriptionLabel.text = ""
		languageLabel.text = ""
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureUI() {
		self.accessoryType = .disclosureIndicator
		
		self.layer.cornerRadius = 16
		self.layer.masksToBounds = true
		
		self.addSubview(stackView)
		
		horizontalStackView.addArrangedSubview(hashTagImageView)
		horizontalStackView.addArrangedSubview(languageLabel)
		
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(horizontalStackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
			
			hashTagImageView.widthAnchor.constraint(equalTo: hashTagImageView.heightAnchor)
		])
	}
}

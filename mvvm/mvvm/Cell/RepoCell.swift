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
	
	lazy var commitLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
		label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
		label.textAlignment = .right
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		titleLabel.text = ""
		descriptionLabel.text = ""
		languageLabel.text = ""
		
		hashTagImageView.image = nil
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
		
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(descriptionLabel)
		
		horizontalStackView.addArrangedSubview(hashTagImageView)
		horizontalStackView.addArrangedSubview(languageLabel)
		horizontalStackView.addArrangedSubview(commitLabel)
		stackView.addArrangedSubview(horizontalStackView)
		
		self.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			
			titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight),
			
			stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
			
			hashTagImageView.widthAnchor.constraint(equalTo: hashTagImageView.heightAnchor)
		])
	}
	
	func configure(repo: Repo) {
		titleLabel.text = repo.name
		
		if let desc = repo.description {
			descriptionLabel.text = desc
		}
		
		if let language = repo.language {
			languageLabel.text = language
			hashTagImageView.image = UIImage(systemName: "number")?.withRenderingMode(.alwaysTemplate)
		}
		
		commitLabel.text = updatedCommitText(repo.updatedDate)
	}
	
	private func updatedCommitText(_ dateString: String) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = .current
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		
		let updateDate = dateFormatter.date(from: dateString)!
		
		var dateString = "Updated "
		
		// within 24 hours
		if let diff = Calendar.current.dateComponents([.hour], from: updateDate, to: Date()).hour, diff < 24 {
			let formatter = RelativeDateTimeFormatter()
			formatter.unitsStyle = .full
			dateString += formatter.localizedString(for: updateDate, relativeTo: Date())
		} else {
			dateString += "on "
			
			dateFormatter.dateFormat = "d"
			dateString += dateFormatter.string(from: updateDate)
			
			dateString += " "
			
			dateFormatter.dateFormat = "MMM"
			dateString += dateFormatter.string(from: updateDate)
			
			// past this year
			if let diff = Calendar.current.dateComponents([.year], from: updateDate, to: Date()).year, diff > 0 {
				
				dateString += " "
				
				dateFormatter.dateFormat = "yyyy"
				dateString += dateFormatter.string(from: updateDate)
			}
		}
		
		return dateString
	}
}

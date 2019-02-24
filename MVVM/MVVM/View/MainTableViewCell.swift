//
//  MainTableViewCell.swift
//  MVC
//
//  Created by hy_sean on 17/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  
  lazy var avatarView: UIImageView = {
    let iv = UIImageView()
    iv.layer.cornerRadius = 30
    iv.clipsToBounds = true
    iv.backgroundColor = .black
    return iv
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 4
    return stackView
  }()
  
  lazy var repoTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
    return label
  }()
  
  lazy var languageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
    return label
  }()
  
  lazy var horizonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    return stackView
  }()
  
  lazy var starsLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    return label
  }()
  
  lazy var updateDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textAlignment = .right
    return label
  }()
  
  lazy var labelList = [repoTitleLabel, languageLabel, starsLabel, updateDateLabel]
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(avatarView)
    addSubview(verticalStackView)
    addSubview(horizonStackView)
    
    labelList.enumerated().forEach { (index, label) in
      if index < labelList.count / 2 {
        verticalStackView.addArrangedSubview(label)
      } else {
        horizonStackView.addArrangedSubview(label)
      }
    }
    
    avatarView.anchor(top: topAnchor,
                      leading: safeAreaLayoutGuide.leadingAnchor,
                      bottom: bottomAnchor,
                      trailing: nil,
                      padding: .init(top: 12, left: 12, bottom: 12, right: 0),
                      size: .init(width: 60, height: 60))
    
    verticalStackView.anchor(top: topAnchor,
                     leading: avatarView.trailingAnchor,
                     bottom: nil,
                     trailing: trailingAnchor,
                     padding: .init(top: 12, left: 8, bottom: 0, right: 8))
    
    horizonStackView.anchor(top: verticalStackView.bottomAnchor,
                            leading: avatarView.trailingAnchor,
                            bottom: bottomAnchor,
                            trailing: safeAreaLayoutGuide.trailingAnchor,
                            padding: .init(top: 8, left: 8, bottom: 12, right: 12))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
	
	func setupCell(_ viewModel: SearchViewModel, _ index: Int) {
		
		let item = viewModel.getItem(at: index)
		
		if let imageUrl = item?.owner?.avatarUrl {
			URLSession.shared.request(urlString: imageUrl) { [weak self] (data, res, error) in
				guard let data = data else { return }
				self?.avatarView.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
			}
		}
		
		repoTitleLabel.text = item?.fullName
		languageLabel.text = "\(item?.language ?? "Not Found Language")"
		starsLabel.text = "\(String(item?.star?.abbreviated ?? "0")) Stars"
		
		if let updatedDate = item?.updatedDate {
			updateDateLabel.text = "updated \(updatedDate.dateFormat)"
		}
	}
}

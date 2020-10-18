//
//  ProfileViewController.swift
//  viper
//
//  Created by hy_sean on 2020/10/17.
//

import UIKit

class ProfileViewController: UIViewController {
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		
		imageView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
		
		imageView.layer.cornerRadius = self.view.frame.width / 4
		imageView.layer.masksToBounds = true
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	lazy var textField: UITextField = {
		let textField = UITextField()
		textField.attributedPlaceholder = NSAttributedString(
			string: "enter your github id",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
		)
		textField.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
		textField.textColor = .black
		textField.textAlignment = .center
		
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		
		textField.delegate = self
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}()
	
	/// textField 하단 뷰.
	lazy var underLine: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1.0)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	/// user id 상태 이미지 뷰.
	lazy var confirmImageView: UIImageView = {
		let imageView = UIImageView()
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	lazy var submitButton: UIButton = {
		let button = UIButton(type: .custom)
		
		button.isEnabled = false
		
		button.backgroundColor = button.isEnabled ? UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0) : .lightGray
		
		button.layer.cornerRadius = 16
		button.layer.masksToBounds = true
		
		button.setTitle("NEXT", for: .normal)
		button.setTitleColor(.white, for: .normal)
		
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	var isSetupConfirmImage: Bool = false {
		willSet {
			confirmImageView.image = UIImage(systemName: newValue ? "checkmark.circle.fill" : "multiply")?.withRenderingMode(.alwaysTemplate)
			confirmImageView.tintColor = newValue ? .systemBlue : .red
		}
	}
	
	let presenter: ProfilePresenter
	
	init(presenter: ProfilePresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
		bind()
	}
	
	func configureUI() {
		
		view.backgroundColor = .white
		
		view.addSubview(profileImageView)
		
		view.addSubview(textField)
		textField.addSubview(underLine)
		
		view.addSubview(confirmImageView)
		
		view.addSubview(submitButton)
		
		NSLayoutConstraint.activate([
			profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 6),
			profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			profileImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
			
			textField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: view.frame.height / 6),
			textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textField.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
			textField.heightAnchor.constraint(equalToConstant: 42),
			
			underLine.heightAnchor.constraint(equalToConstant: 1),
			underLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
			underLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
			underLine.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
			
			confirmImageView.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 0.7),
			confirmImageView.widthAnchor.constraint(equalTo: confirmImageView.heightAnchor),
			confirmImageView.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 12),
			confirmImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
			
			submitButton.heightAnchor.constraint(equalToConstant: 44),
			submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: view.frame.height / 6),
			submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
			submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
		])
	}
	
	func bind() {
		submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
		
		presenter.avatarURL.bind { [weak self] avatarURL in
			DispatchQueue.main.async {
				
				let isSuccessRetrieveURL = !avatarURL.isEmpty
				
				if isSuccessRetrieveURL {
					self?.profileImageView.setupImage(from: avatarURL)
				} else {
					self?.profileImageView.image = nil
				}
				
				self?.submitButton.isEnabled = isSuccessRetrieveURL
				self?.isSetupConfirmImage = isSuccessRetrieveURL
			}
		}
	}
	
	@objc func didTapSubmitButton() {
		present(UINavigationController(rootViewController: presenter.builder()), animated: true)
	}
}

extension ProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		guard let text = textField.text, !text.isEmpty else { return false }
		
		self.view.endEditing(true)
		
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		guard let userID = textField.text else { return }
		
		if let _ = profileImageView.image {
			self.profileImageView.image = nil
		}
		
		presenter.setUserID(userID)
	}
}

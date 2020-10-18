//
//  UIImageView+Extension.swift
//  viper
//
//  Created by hy_sean on 2020/10/18.
//

import UIKit

extension UIImageView {
	func setupImage(from url: String) {
		
		guard let url = URL(string: url) else { return }
		
		do {
			self.image = UIImage(data: try Data(contentsOf: url))
		} catch let error {
			print(error)
		}
	}
}

//
//  UIImageView+Extension.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/21.
//  Copyright © 2020 siwon. All rights reserved.
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

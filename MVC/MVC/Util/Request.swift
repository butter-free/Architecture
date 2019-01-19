//
//  Request.swift
//  MVC
//
//  Created by hy_sean on 19/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

struct Request {
  static func search(_ query: String, completion: @escaping (_ searchItems: Search?, _ error: Error?) -> Void ) {
    
    guard !query.isEmpty else { return }
    
    let apiUrl: String = "https://api.github.com/search/repositories?q=\(query)&sort=stars&order=desc"
    
    URLSession.shared.requestModel(urlString: apiUrl) { (data: Search?, res, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let data = data else { return }
      
      completion(data, nil)
    }
  }
}

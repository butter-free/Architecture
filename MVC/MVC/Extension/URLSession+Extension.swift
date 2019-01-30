//
//  URLSession+Extension.swift
//  MVC
//
//  Created by hy_sean on 18/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

extension URLSession {
  
  func request(urlString: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, res, error) in
      DispatchQueue.main.async {
        
        guard let httpRes = res as? HTTPURLResponse else { return }
        
        if let error = error {
          completion(nil, httpRes, error)
          return
        }
        
        completion(data, httpRes, nil)
      }
      }.resume()
    
  }
  
  func requestModel<T: Decodable>(urlString: String, completion: @escaping (_ data: T?, _ response: URLResponse?, _ error: Error?) -> Void) {
    
    request(urlString: urlString) { (data, res, error) in
      
      if let error = error {
        completion(nil, res, error)
        return
      }
      
      guard let modelData = ModelDecoder<T>(data: data!).parse else { return }
      completion(modelData, res, nil)
    }
  }
}

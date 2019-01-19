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
        let statusCode = httpRes.statusCode
        
        guard statusCode == 200 else {
          print("[Response] \(statusCode)")
          return
        }
        
        if let error = error {
          completion(nil, httpRes, error)
          return
        }
        
        guard let data = data else { return }
        
        completion(data, httpRes, nil)
      }
      }.resume()
    
  }
  
  func requestModel<T: Decodable>(urlString: String, completion: @escaping (_ data: T?, _ response: URLResponse?, _ error: Error?) -> Void) {
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, res, error) in
      DispatchQueue.main.async {
        
        guard let httpRes = res as? HTTPURLResponse else { return }
        let statusCode = httpRes.statusCode
        
        guard statusCode == 200 else {
          print("[Response] \(statusCode)")
          return
        }
        
        if let error = error {
          completion(nil, httpRes, error)
          return
        }
        
        guard let data = data else { return }
        guard let modelData = ModelDecoder<T>(data: data).parse else { return }
        
        completion(modelData, httpRes, nil)
      }
    }.resume()
    
  }
}

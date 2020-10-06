//
//  NetworkManager.swift
//  mvvm
//
//  Created by hy_sean on 2020/08/21.
//  Copyright © 2020 siwon. All rights reserved.
//

import Foundation

protocol NetworkService {
	func request<T>(url: String, result: @escaping (Result<T, Error>) -> Void) where T : Decodable
}

enum NetworkError: Error {
	case invalidStatus(code: Int)
}

class NetworkManager: NetworkService {
	
	static let shared: NetworkManager = NetworkManager()
	
	func request<T>(url: String, result: @escaping (Result<T, Error>) -> Void) where T : Decodable {
		
		guard let url = URL(string: url) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			if let error = error {
				result(.failure(error))
				return
			}
			
			let httpResponse = response as! HTTPURLResponse
			
			guard let data = data, (200...300) ~= httpResponse.statusCode else {
				result(.failure(NetworkError.invalidStatus(code: httpResponse.statusCode)))
				return
			}
			
			do {
				let data = try JSONDecoder().decode(T.self, from: data)
				
				result(.success(data))
				return
			} catch let error {
				result(.failure(error))
			}
			
		}.resume()
	}
}

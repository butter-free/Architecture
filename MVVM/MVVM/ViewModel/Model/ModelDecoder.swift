//
//  ModelDecoder.swift
//  MVC
//
//  Created by hy_sean on 19/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import Foundation

struct ModelDecoder<T> {
  let parse: T?
}

extension ModelDecoder where T: Decodable {
  init(data: Data) {
    self.parse = try? JSONDecoder().decode(T.self, from: data)
  }
}

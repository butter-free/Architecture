//
//  MVCTests.swift
//  MVCTests
//
//  Created by hy_sean on 11/01/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import XCTest
@testable import MVC

class MVCTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testDateConverter() {
    let dateString = "2019-01-16T14:10:43Z"
    let resultDateString = dateString.dateFormat
    
    let result = resultDateString == "Jan 16, 2:10 PM" ? true : false
    
    XCTAssert(result, "wrong date format")
  }
  
  func testNumberFomatter() {
    let stars: Int = 1100000
    let formatter = stars.abbreviated
    let result = formatter == "1.1m" ? true : false
    
    XCTAssert(result, "success number formatter")
  }
}

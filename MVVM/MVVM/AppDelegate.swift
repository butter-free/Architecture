//
//  AppDelegate.swift
//  MVVM
//
//  Created by hy_sean on 08/02/2019.
//  Copyright © 2019 hy_sean. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let navController = UINavigationController(rootViewController: MainTableController())
    window?.rootViewController = navController
    return true
  }
}


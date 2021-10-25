//
//  AppDelegate.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        navigationController.pushViewController(UserViewController(), animated: false)
        window?.makeKeyAndVisible()
        
        return true
    }
}

//
//  AppDelegate.swift
//  DromTestApp
//
//  Created by Владимир on 21.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window: UIWindow = .init(frame: UIScreen.main.bounds)
        let vc: UIViewController = ViewController()
        let navigationVC: UINavigationController = .init(rootViewController: vc)
        navigationVC.hidesBarsOnSwipe = true
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}


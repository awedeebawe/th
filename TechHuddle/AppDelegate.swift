//
//  AppDelegate.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = ViewModel()
        
        let listViewController = BarsListViewController()
        listViewController.tabBarItem.title = Constants.listTab
        listViewController.tabBarItem.image = #imageLiteral(resourceName: "list") // I love this Image Literal feature <3
        listViewController.viewModel = viewModel
        
        let mapViewController = BarsMapViewController()
        mapViewController.tabBarItem.title = Constants.mapTab
        mapViewController.tabBarItem.image = #imageLiteral(resourceName: "map") // Except when the images are white on white background :D
        mapViewController.viewModel = viewModel
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [listViewController, mapViewController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}


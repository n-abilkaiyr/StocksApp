//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Assembly.assembler.tabBarController()
        window?.makeKeyAndVisible()
        return true
    }


}


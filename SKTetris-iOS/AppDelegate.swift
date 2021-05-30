//
//  AppDelegate.swift
//  SKTetris-iOS
//
//  Created by Christophe SAUVEUR on 19/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SettingsManager.initialize()
        SoundManager.preloadSounds()
        
        self.window = self.window ?? UIWindow()
        self.window!.backgroundColor = UIColor.gray
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        
        return true
    }

}


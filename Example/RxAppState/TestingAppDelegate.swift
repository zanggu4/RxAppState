//
//  TestingAppDelegate.swift
//  RxAppState
//
//  Created by Jörn Schoppe on 19.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}


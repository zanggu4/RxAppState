//
//  main.swift
//  RxAppState
//
//  Created by Jörn Schoppe on 19.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

if isRunningTests {
    UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(TestingAppDelegate))
} else {
    UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(AppDelegate))
}

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
    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(
                to: UnsafeMutablePointer<Int8>.self,
                capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(TestingAppDelegate.self)
    )
} else {
    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(
                to: UnsafeMutablePointer<Int8>.self,
                capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(AppDelegate.self)
    )
}

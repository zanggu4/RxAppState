//
//  RxAppState_ExampleTests.swift
//  RxAppState_ExampleTests
//
//  Created by Jörn Schoppe on 19.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import RxAppState_Example
import RxSwift
import RxCocoa
import RxAppState

class RxAppStateTests: XCTestCase {
    
    var firstLaunchKey:String { return "RxAppState_didLaunchBefore" }
    var numDidOpenAppKey:String { return "RxAppState_numDidOpenApp" }
    
    let application = UIApplication.sharedApplication()
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(firstLaunchKey)
        userDefaults.removeObjectForKey(numDidOpenAppKey)
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = DisposeBag()
    }
    
    func testAppStates() {
        // Given
        var appStates: [AppState] = []
        application.rx_appState
            .subscribeNext { appState in
                appStates.append(appState)
            }
            .addDisposableTo(disposeBag)
        
        // When
        application.delegate?.applicationDidBecomeActive!(application)
        application.delegate?.applicationWillResignActive!(application)
        application.delegate?.applicationDidEnterBackground!(application)
        application.delegate?.applicationWillTerminate!(application)
        
        // Then
        XCTAssertEqual(appStates, [AppState.Active, AppState.Inactive, AppState.Background, AppState.Terminated])
    }
    
    func testDidOpenApp() {
        // Given
        var didOpenAppCalledCount = 0
        application.rx_didOpenApp
            .subscribeNext { _ in
                didOpenAppCalledCount += 1
            }
            .addDisposableTo(disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(didOpenAppCalledCount, 3)
    }
    
    func testDidOpenAppCount() {
        // Given
        var didOpenAppCounts: [Int] = []
        application.rx_didOpenAppCount
            .subscribeNext { count in
                didOpenAppCounts.append(count)
            }
            .addDisposableTo(disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(didOpenAppCounts, [1,2,3])
    }
    
    func testFirstLaunch() {
        // Given
        var firstLaunchArray: [Bool] = []
        application.rx_firstLaunch
            .subscribeNext { isFirstLaunch in
                firstLaunchArray.append(isFirstLaunch)
            }
            .addDisposableTo(disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true, false, false])
    }
    
    func runAppStateSequence() {
        application.delegate?.applicationDidBecomeActive!(application)
        application.delegate?.applicationWillResignActive!(application)
        application.delegate?.applicationDidBecomeActive!(application)
        application.delegate?.applicationDidEnterBackground!(application)
        application.delegate?.applicationDidBecomeActive!(application)
        application.delegate?.applicationDidEnterBackground!(application)
        application.delegate?.applicationDidBecomeActive!(application)
    }
}

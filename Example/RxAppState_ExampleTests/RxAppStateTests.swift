//
//  RxAppState_ExampleTests.swift
//  RxAppState_ExampleTests
//
//  Created by Jörn Schoppe on 19.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxAppState_Example
@testable import RxAppState

class RxAppStateTests: XCTestCase {
    
    fileprivate var isFirstLaunchKey:String { return "RxAppState_isFirstLaunch" }
    fileprivate var firstLaunchOnlyKey:String { return "RxAppState_firstLaunchOnly" }
    fileprivate var numDidOpenAppKey:String { return "RxAppState_numDidOpenApp" }
    fileprivate var lastAppVersionKey:  String { return "RxAppState_lastAppVersion" }

    let application = UIApplication.shared
    var disposeBag = DisposeBag()
    
    override func tearDown() {
        super.tearDown()
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: isFirstLaunchKey)
        userDefaults.removeObject(forKey: firstLaunchOnlyKey)
        userDefaults.removeObject(forKey: numDidOpenAppKey)
        userDefaults.removeObject(forKey: lastAppVersionKey)
        RxAppState.clearSharedObservables()
        disposeBag = DisposeBag()
    }
    
    func testAppStates() {
        // Given
        var appStates: [AppState] = []
        application.rx.appState
            .subscribe(onNext: { appState in
                appStates.append(appState)
            })
            .disposed(by: disposeBag)
        
        // When
        application.delegate?.applicationDidBecomeActive!(application)
        application.delegate?.applicationWillResignActive!(application)
        application.delegate?.applicationDidEnterBackground!(application)
        application.delegate?.applicationWillTerminate!(application)
        
        // Then
        XCTAssertEqual(appStates, [AppState.active, AppState.inactive, AppState.background, AppState.terminated])
    }
    
    func testDidOpenApp() {
        // Given
        var didOpenAppCalledCount = 0
        application.rx.didOpenApp
            .subscribe(onNext: { _ in
                didOpenAppCalledCount += 1
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(didOpenAppCalledCount, 3)
    }
    
    func testDidOpenAppCount() {
        // Given
        var didOpenAppCounts: [Int] = []
        application.rx.didOpenAppCount
            .subscribe(onNext: { count in
                didOpenAppCounts.append(count)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(didOpenAppCounts, [1,2,3])
    }
    
    func testIsFirstLaunch() {
        // Given
        var firstLaunchArray: [Bool] = []
        application.rx.isFirstLaunch
            .subscribe(onNext: { isFirstLaunch in
                firstLaunchArray.append(isFirstLaunch)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true, false, false])
    }
    
    func testFirstLaunchOnly() {
        // Given
        var firstLaunchArray: [Bool] = []
        application.rx.firstLaunchOnly
            .subscribe(onNext: { _ in
                firstLaunchArray.append(true)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true])

        // And
        XCTAssertEqual(UserDefaults.standard.bool(forKey: self.isFirstLaunchKey), true)
    }
    
    func testIsFirstLaunchOfNewVersionNewInstall() {
        // Given
        var firstLaunchArray: [Bool] = []
        application.rx.isFirstLaunchOfNewVersion
            .subscribe(onNext: { isFirstLaunchOfNewVersion in
                firstLaunchArray.append(isFirstLaunchOfNewVersion)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [false, false, false])
    }
    
    func testIsFirstLaunchOfNewVersionUpdate() {
        // Given
        var firstLaunchArray: [Bool] = []
        UserDefaults.standard.set("3.2", forKey: self.lastAppVersionKey)
        UserDefaults.standard.synchronize()
        RxAppState.currentAppVersion = "4.2"
        
        application.rx.isFirstLaunchOfNewVersion
            .subscribe(onNext: { isFirstLaunchOfNewVersion in
                firstLaunchArray.append(isFirstLaunchOfNewVersion)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true, false, false])
    }
    
    func testIsFirstLaunchOfNewVersionUpdateMultipleSubscription() {
        // Given
        var firstLaunchArray: [Bool] = []
        var anotherFirstLaunchArray: [Bool] = []
        UserDefaults.standard.set("3.2", forKey: self.lastAppVersionKey)
        UserDefaults.standard.synchronize()
        RxAppState.currentAppVersion = "4.2"
        
        application.rx.isFirstLaunchOfNewVersion
            .subscribe(onNext: { isFirstLaunchOfNewVersion in
                firstLaunchArray.append(isFirstLaunchOfNewVersion)
            })
            .disposed(by: disposeBag)
        
        application.rx.isFirstLaunchOfNewVersion
            .subscribe(onNext: { isFirstLaunchOfNewVersion in
                anotherFirstLaunchArray.append(isFirstLaunchOfNewVersion)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true, false, false])
        XCTAssertEqual(anotherFirstLaunchArray, [true, false, false])
    }
    
    func testIsFirstLaunchOfNewVersionExisting() {
        // Given
        var firstLaunchArray: [Bool] = []
        UserDefaults.standard.set("4.2", forKey: self.lastAppVersionKey)
        UserDefaults.standard.synchronize()
        RxAppState.currentAppVersion = "4.2"
        
        application.rx.isFirstLaunchOfNewVersion
            .subscribe(onNext: { isFirstLaunchOfNewVersion in
                firstLaunchArray.append(isFirstLaunchOfNewVersion)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [false, false, false])
    }
    
    func testFirstLaunchOfNewVersionOnlyNewInstall() {
        // Given
        var firstLaunchArray: [Bool] = []
        application.rx.firstLaunchOfNewVersionOnly
            .subscribe(onNext: { _ in
                firstLaunchArray.append(true)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [])
    }
    
    func testFirstLaunchOfNewVersionOnlyNewUpdate() {
        // Given
        var firstLaunchArray: [Bool] = []
        UserDefaults.standard.set("3.2", forKey: self.lastAppVersionKey)
        UserDefaults.standard.synchronize()
        RxAppState.currentAppVersion = "4.2"
        
        application.rx.firstLaunchOfNewVersionOnly
            .subscribe(onNext: { _ in
                firstLaunchArray.append(true)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [true])

        // And
        XCTAssertEqual(UserDefaults.standard.string(forKey: self.lastAppVersionKey), "4.2")
    }
    
    func testFirstLaunchOfNewVersionOnlyExisting() {
        // Given
        var firstLaunchArray: [Bool] = []
        UserDefaults.standard.set("4.2", forKey: self.lastAppVersionKey)
        UserDefaults.standard.synchronize()
        RxAppState.currentAppVersion = "4.2"
        
        application.rx.firstLaunchOfNewVersionOnly
            .subscribe(onNext: { _ in
                firstLaunchArray.append(true)
            })
            .disposed(by: disposeBag)
        
        // When
        runAppStateSequence()
        
        // Then
        XCTAssertEqual(firstLaunchArray, [])
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

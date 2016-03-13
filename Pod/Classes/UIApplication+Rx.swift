//
//  UIApplication+Rx.swift
//  Pods
//
//  Created by Jörn Schoppe on 29.02.16.
//  Copyright © 2015 Jörn Schoppe. All rights reserved.
//

import RxSwift
import RxCocoa

public enum AppState: Equatable {
    case Active
    case Inactive
    case Background
    case Terminated
}

public func ==(lhs: AppState, rhs: AppState) -> Bool {
    switch (lhs, rhs) {
    case (.Active, .Active),
         (.Inactive, .Inactive),
         (.Background, .Background),
         (.Terminated, .Terminated):
        return true
    default:
        return false
    }
}

extension UIApplication {
    
    private var firstLaunchKey:String { return "RxAppState_didLaunchBefore" }
    private var numDidOpenAppKey:String { return "RxAppState_numDidOpenApp" }
    
    public var rx_delegate: DelegateProxy {
        return proxyForObject(RxApplicationDelegateProxy.self, self)
    }
    
    public var rx_applicationDidBecomeActive: Observable<AppState> {
        return rx_delegate.observe(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map { _ in
                return .Active
            }
    }
    
    public var rx_applicationDidEnterBackground: Observable<AppState> {
        return rx_delegate.observe(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map { _ in
                return .Background
            }
    }
    
    public var rx_applicationWillResignActive: Observable<AppState> {
        return rx_delegate.observe(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map { _ in
                return .Inactive
            }
    }
    
    public var rx_applicationWillTerminate: Observable<AppState> {
        return rx_delegate.observe(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map { _ in
                return .Terminated
            }
    }
    
    public var rx_appState: Observable<AppState> {
        return Observable.of(
            rx_applicationDidBecomeActive,
            rx_applicationWillResignActive,
            rx_applicationDidEnterBackground,
            rx_applicationWillTerminate
            )
            .merge()
    }
    
    public var rx_didOpenApp: Observable<Void> {
        return Observable.of(
            rx_applicationDidBecomeActive,
            rx_applicationDidEnterBackground
            )
            .merge()
            .distinctUntilChanged()
            .filter { $0 == .Active }
            .map { _ in
                return
            }
    }
    
    public var rx_didOpenAppCount: Observable<Int> {
        return rx_didOpenApp
            .map { _ in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                var count = userDefaults.integerForKey(self.numDidOpenAppKey)
                count = min(count + 1, Int.max - 1)
                userDefaults.setInteger(count, forKey: self.numDidOpenAppKey)
                userDefaults.synchronize()
                return count
            }
    }
    
    public var rx_firstLaunch: Observable<Bool> {
        return rx_applicationDidBecomeActive
            .map { _ in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let didLaunchBefore = userDefaults.boolForKey(self.firstLaunchKey)
                
                if didLaunchBefore {
                    return false
                } else {
                    userDefaults.setBool(true, forKey: self.firstLaunchKey)
                    userDefaults.synchronize()
                    return true
                }
            }
    }
}

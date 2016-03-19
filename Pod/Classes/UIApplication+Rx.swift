//
//  UIApplication+Rx.swift
//  Pods
//
//  Created by Jörn Schoppe on 29.02.16.
//  Copyright © 2015 Jörn Schoppe. All rights reserved.
//

import RxSwift
import RxCocoa

/**
 UIApplication states
 
 There are two more app states in the Apple Docs ("Not running" and "Suspended").
 I decided to ignore those two states because there are no UIApplicationDelegate
 methods for those states.
 */
public enum AppState: Equatable {
    /**
     The application is running in the foreground.
     */
    case Active
    /**
     The application is running in the foreground but not receiving events.
     Possible reasons:
     - The user has opens Notification Center or Control Center
     - The user receives a phone call
     - A system prompt is shown (e.g. Request to allow Push Notifications)
     */
    case Inactive
    /**
     The application is in the background because the user closed it.
     */
    case Background
    /**
     The application is about to be terminated by the system
     */
    case Terminated
}

/**
 Equality function for AppState
 */
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
    
    /**
     Keys for NSUserDefaults
     */
    private var firstLaunchKey:String { return "RxAppState_didLaunchBefore" }
    private var numDidOpenAppKey:String { return "RxAppState_numDidOpenApp" }
    
    /**
     Reactive wrapper for `delegate`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var rx_delegate: DelegateProxy {
        return proxyForObject(RxApplicationDelegateProxy.self, self)
    }
    
    /**
     Reactive wrapper for `delegate` message `applicationDidBecomeActive(_:)`.
     */
    public var rx_applicationDidBecomeActive: Observable<AppState> {
        return rx_delegate.observe("applicationDidBecomeActive:")
            .map { _ in
                return .Active
        }
    }
    
    /**
     Reactive wrapper for `delegate` message `applicationDidEnterBackground(_:)`.
     */
    public var rx_applicationDidEnterBackground: Observable<AppState> {
        return rx_delegate.observe("applicationDidEnterBackground:")
            .map { _ in
                return .Background
        }
    }
    
    /**
     Reactive wrapper for `delegate` message `applicationWillResignActive(_:)`.
     */
    public var rx_applicationWillResignActive: Observable<AppState> {
        return rx_delegate.observe("applicationWillResignActive:")
            .map { _ in
                return .Inactive
        }
    }
    
    /**
     Reactive wrapper for `delegate` message `applicationWillTerminate(_:)`.
     */
    public var rx_applicationWillTerminate: Observable<AppState> {
        return rx_delegate.observe("applicationWillTerminate:")
            .map { _ in
                return .Terminated
        }
    }
    
    /**
     Observable sequence of the application's state
     
     This gives you an observable sequence of all possible application states.
     
     - returns: Observable sequence of AppStates
     */
    public var rx_appState: Observable<AppState> {
        return Observable.of(
            rx_applicationDidBecomeActive,
            rx_applicationWillResignActive,
            rx_applicationDidEnterBackground,
            rx_applicationWillTerminate
            )
            .merge()
    }
    
    /**
     Observable sequence that emits a value whenever the user opens the app
     
     This is a handy sequence if you want to run some code everytime
     the user opens the app.
     It ignores `applicationDidBecomeActive(_:)` calls when the app was not
     in the background but only in inactive state (because the user
     opened control center or received a call).
     
     Typical use cases:
     - Track when the user opens the app.
     - Refresh data on app start
     
     - returns: Observable sequence of Void
     */
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
    
    /**
     Observable sequence that emits the number of times a user has opened the app
     
     This is a handy sequence if you want to know how many times the user has opened your app
     
     Typical use cases:
     - Ask a user to review your app after when he opens it for the 10th time
     - Track the number of times a user has opened the app
     
     -returns: Observable sequence of Int
     */
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
    
    /**
     Observable sequence that emits if the app is opened for the first time
     
     This is a handy sequence for all the times you want to run some code only
     when the app is launched for the first time
     
     Typical use case:
     - Show a tutorial to a new user
     
     -returns: Observable sequence of Bool
     */
    public var rx_firstLaunch: Observable<Bool> {
        return rx_didOpenApp
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

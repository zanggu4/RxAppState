//
//  UIApplication+Rx.swift
//  Pods
//
//  Created by Jörn Schoppe on 29.02.16.
//  Copyright © 2015 Jörn Schoppe. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: AppState

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

// MARK: Rx

extension UIApplication {
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
}

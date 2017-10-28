//
//  UIViewController+Rx.swift
//  Pods-RxAppState_Example
//
//  Created by Jörn Schoppe on 28.10.17.
//

import RxSwift
import RxCocoa

/**
 ViewController view states
*/
public enum ViewControllerViewState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    
    public static func ==(lhs: ViewControllerViewState, rhs: ViewControllerViewState) -> Bool {
        switch (lhs, rhs) {
        case (.viewWillAppear, .viewWillAppear),
             (.viewDidAppear, .viewDidAppear),
             (.viewWillDisappear, .viewWillDisappear),
             (.viewDidDisappear, .viewDidDisappear):
            return true
        default:
            return false
        }
    }
}

/**
 UIViewController view state changes
 
 The original UIViewController methods have a parameter 'animated'
 I almost never use that parameter and therefor decided to just emit Void
 in these Observables. This
 */

extension RxSwift.Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<ViewControllerViewState> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in return .viewWillAppear }
    }
    
    public var viewDidAppear: Observable<ViewControllerViewState> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { _ in return .viewDidAppear }
    }
    
    public var viewWillDisappear: Observable<ViewControllerViewState> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { _ in return .viewWillDisappear }
    }
    
    public var viewDidDisappear: Observable<ViewControllerViewState> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { _ in return .viewDidDisappear }
    }
    
    /**
     Observable sequence of the view controller's view state
     
     This gives you an observable sequence of all possible states.
     
     - returns: Observable sequence of AppStates
     */
    public var viewState: Observable<ViewControllerViewState> {
        return Observable.of(
            viewWillAppear,
            viewDidAppear,
            viewWillDisappear,
            viewDidDisappear
            )
            .merge()
    }
}

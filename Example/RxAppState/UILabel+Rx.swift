//
//  UILabel+Rx.swift
//  RxAppState
//
//  Created by Jörn Schoppe on 06.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

extension UILabel {
    public var rx_appState: AnyObserver<AppState> {
        return UIBindingObserver(UIElement: self) { label, appState in
            switch appState {
            case .Active:
                label.backgroundColor = UIColor.greenColor()
                label.text = "ACTIVE"
            case .Inactive:
                label.backgroundColor = UIColor.yellowColor()
                label.text = "INACTIVE"
            case .Background:
                label.backgroundColor = UIColor.redColor()
                label.text = "BACKGROUND"
            case .Terminated:
                label.backgroundColor = UIColor.lightGrayColor()
                label.text = "TERMINATED"
            }
        }
        .asObserver()
    }
    
    public var rx_firstLaunch: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self) { label, isFirstLaunch in
            if isFirstLaunch {
                label.backgroundColor = UIColor.greenColor()
                label.text = "YES"
            } else {
                label.backgroundColor = UIColor.redColor()
                label.text = "NO"
            }
        }
        .asObserver()
    }
}

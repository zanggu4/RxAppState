//
//  RxApplicationDelegateProxy.swift
//  UIApplication+Rx
//
//  Created by Jörn Schoppe on 29.02.16.
//  Copyright © 2015 Jörn Schoppe. All rights reserved.
//

import RxSwift
import RxCocoa

class RxApplicationDelegateProxy: DelegateProxy, UIApplicationDelegate, DelegateProxyType {
    
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let application: UIApplication = object as! UIApplication
        return application.delegate
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let application: UIApplication = object as! UIApplication
        application.delegate = delegate as? UIApplicationDelegate
    }
    
    override func setForwardToDelegate(delegate: AnyObject?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: true)
    }
}

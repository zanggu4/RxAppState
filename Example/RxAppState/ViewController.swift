//
//  ViewController.swift
//  RxAppState
//
//  Created by Jörn Schoppe on 03/06/2016.
//  Copyright (c) 2016 Jörn Schoppe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

class ViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var showAlertButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlertButton.rx_tap
            .subscribeNext {
                // use this to trigger a system prompt that puts the app in an inactive state
                let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            }
            .addDisposableTo(disposeBag)
        
        let application = UIApplication.sharedApplication()
        Observable.of(
            application.rx_applicationDidBecomeActive,
            application.rx_applicationWillResignActive,
            application.rx_applicationDidEnterBackground,
            application.rx_applicationWillTerminate
            )
            .merge()
            .bindTo(stateLabel.rx_appState)
            .addDisposableTo(disposeBag)
    }
}
	
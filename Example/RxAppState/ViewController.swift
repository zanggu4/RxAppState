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
    @IBOutlet weak var firstLaunchLabel: UILabel!
    @IBOutlet weak var appOpenedLabel: UILabel!
    @IBOutlet weak var firstLaunchAfterUpdateLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var simulateUpdateButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupExampleUI()
        
        let application = UIApplication.shared
        
        /**
        Show the application state
        */
        application.rx.appState
            .bindTo(stateLabel.rx_appState)
            .addDisposableTo(disposeBag)
        
        /**
        Show if the app is launched for the first time
        */
        application.rx.isFirstLaunch
            .bindTo(firstLaunchLabel.rx_firstLaunch)
            .addDisposableTo(disposeBag)
        
        /**
        Show how many times the app has been opened
        */
        application.rx.didOpenAppCount
            .subscribe(onNext: { count in
                self.appOpenedLabel.text = count == 1 ? "1 time" : "\(count) times"
            })
            .addDisposableTo(disposeBag)
        
        /**
         Show if the app is launched for the first time after an update
         */
        application.rx.isFirstLaunchOfNewVersion
            .bindTo(firstLaunchAfterUpdateLabel.rx_firstLaunch)
            .addDisposableTo(disposeBag)
    }
    
    func setupExampleUI() {
        appVersionLabel.text = RxAppState.currentAppVersion
        
        simulateUpdateButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.simulateAppUpdate()
            })
            .addDisposableTo(disposeBag)
    }
    
    func simulateAppUpdate() {
        guard let currentMinorVersion = RxAppState.currentAppVersion?.components(separatedBy: ".").last else { return }
        let minorVersion = Int(currentMinorVersion) ?? 0
        let newSimulatedAppVersion = "1.\(minorVersion + 1)"
        RxAppState.currentAppVersion = newSimulatedAppVersion
        appVersionLabel.text = newSimulatedAppVersion
    }
}
	

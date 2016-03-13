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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let application = UIApplication.sharedApplication()
        
        application.rx_appState
            .bindTo(stateLabel.rx_appState)
            .addDisposableTo(disposeBag)
        
        application.rx_firstLaunch
            .bindTo(firstLaunchLabel.rx_firstLaunch)
            .addDisposableTo(disposeBag)
        
        application.rx_didOpenAppCount
            .subscribeNext { count in
                self.appOpenedLabel.text = count == 1 ? "1 time" : "\(count) times"
            }
            .addDisposableTo(disposeBag)
    }
}
	
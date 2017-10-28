//
//  SecondaryViewController.swift
//  RxAppState_Example
//
//  Created by Jörn Schoppe on 28.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

class SecondaryViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.viewState
            .bind(to: label.rx_viewState)
            .disposed(by: disposeBag)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

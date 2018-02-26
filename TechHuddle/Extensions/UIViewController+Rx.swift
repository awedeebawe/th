//
//  UIViewController+Rx.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    /// Error binder
    var error: Binder<String> {
        return Binder(self.base, binding: { (viewController, value) in
            
            let alertController = UIAlertController(title: Constants.alertTitle, message: value, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: Constants.alertClose, style: .cancel)
            alertController.addAction(closeAction)
            
            self.base.present(alertController, animated: true)
        })
    }
}

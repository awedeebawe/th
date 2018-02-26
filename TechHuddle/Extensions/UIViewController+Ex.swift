//
//  UIViewController+Ex.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     "Stretch" the given view to fill the whole screen :)
     
     - parameter viewToStretch: view to fill the whole screen
     */
    func stretch(_ viewToStretch: UIView) {
        guard view.subviews.contains(viewToStretch) else {
            fatalError("Nah, the given UIView object is not part of the View Controller's view hierarchy! Did you call `addSubview(_ view: UIView)` first? :)")
        }
        
        viewToStretch.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
                        "view": viewToStretch
                    ]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views)
        view.addConstraints(verticalConstraints)
        view.addConstraints(horizontalConstraints)
    }
    
    /**
     Center the given view in the middle of the screen
 
     - parameter viewToCenter: view to center vertically and horizontally
    */
    func center(_ viewToCenter: UIView) {
        guard view.subviews.contains(viewToCenter) else {
            fatalError("Nah, the given UIView object is not part of the View Controller's view hierarchy! Did you call `addSubview(_ view: UIView)` first? :)")
        }
        
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "superview": view!,
            "view": viewToCenter
        ]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[superview]-(<=1)-[view]",
                                                                 options: .alignAllCenterX,
                                                                 metrics: nil,
                                                                 views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[view]",
                                                                   options: .alignAllCenterY,
                                                                   metrics: nil,
                                                                   views: views)
        view.addConstraints(verticalConstraints)
        view.addConstraints(horizontalConstraints)
    }
}

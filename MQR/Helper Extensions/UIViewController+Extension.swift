//
//  Extensions.swift
//  MQR
//
//  Created by Nuri Chun on 9/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit


extension UIViewController {
    
    // MARK: - KEYBOARD FUNCTIONALITIES
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenTapped() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTap))
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardTap() {
        self.view.endEditing(true)
    }
    
    // MARK: - ADDING/REMOVING CHILDVIEWCONTROLLER
    
    func add(_ childViewController: UIViewController, containerView: UIView?) {
    
        childViewController.viewLayoutMarginsDidChange()
        childViewController.view.layer.cornerRadius = 20
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        
        if let container = containerView {
            container.addSubview(childViewController.view)
        } else {
            view.addSubview(childViewController.view)
        }
        childViewController.didMove(toParent: self)
    }

    
    func remove(_ childViewController: UIViewController) {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}






















//
//  UIView+Extension.swift
//  MQR
//
//  Created by Nuri Chun on 1/11/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, topPad: CGFloat, leftPad: CGFloat, bottomPad: CGFloat, rightPad: CGFloat, width: CGFloat, height: CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: topPad).isActive = true
        }
        
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: leftPad).isActive = true
        }
        
        if let bottom = bottom
        {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPad).isActive = true
        }
        
        if let right = right
        {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPad).isActive = true
        }
        
        if width != 0
        {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0
        {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

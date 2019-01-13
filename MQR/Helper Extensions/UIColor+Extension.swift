//
//  UIColor+Extension.swift
//  MQR
//
//  Created by Nuri Chun on 1/11/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor
    {
        return UIColor(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static func mainDark() -> UIColor
    {
        return UIColor.rgb(r: 59, g: 56, b: 56)
    }
}

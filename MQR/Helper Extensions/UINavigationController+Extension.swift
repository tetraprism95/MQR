//
//  UINavigationController+Extension.swift
//  MQR
//
//  Created by Nuri Chun on 1/11/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController
{
    override open var childForStatusBarHidden: UIViewController?
    {
        return self.topViewController
    }
}

//
//  AppDelegate.swift
//  MQR
//
//  Created by Nuri Chun on 9/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mapController = MapController()
        window?.rootViewController = mapController
        window?.makeKeyAndVisible()
        return true
    }
}


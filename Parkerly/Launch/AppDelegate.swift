//
//  AppDelegate.swift
//  Parkerly
//
//  Created by Zmicier Zaleznicenka on 2/1/18.
//  Copyright © 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = RootViewController()
        window?.rootViewController = rootViewController
        appCoordinator = AppCoordinator(rootViewController: rootViewController)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }

}


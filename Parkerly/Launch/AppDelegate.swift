//
//  AppDelegate.swift
//  Parkerly
//
//  Created by Zmicier Zaleznicenka on 2/1/18.
//  Copyright © 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let serviceLocator = ServiceLocator()
        let rootViewController = RootViewController()
        appCoordinator = AppCoordinator(serviceLocator: serviceLocator, rootViewController: rootViewController)
        appCoordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

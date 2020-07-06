//
//  AppDelegate.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/23/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    let coreDataStack = CoreDataStack()
    private var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dashboardViewController = DashboardViewController()
        dashboardViewController.viewModel = DashboardViewViewModel(coreDataStack: coreDataStack)
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootNavigationController = UINavigationController(rootViewController: dashboardViewController)
        rootNavigationController.navigationBar.tintColor = .black
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}


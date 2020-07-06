//
//  DashboardRoutes.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/4/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

extension DashboardViewController {

    private var userViewController: UserViewController {
        let userViewController = UserViewController()

        userViewController.viewModel = viewModel?.userViewViewModel

        return userViewController
    }

    private var lightViewController: LightViewController {
        let lightViewController = LightViewController()

        lightViewController.viewModel = viewModel?.lightViewViewModel

        return lightViewController
    }


    func pushUserScreen() {
        navigationController?.pushViewController(userViewController, animated: true)
    }


    func pushLightScreen() {
        navigationController?.pushViewController(lightViewController, animated: true)
    }
}

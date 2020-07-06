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

    func pushUserScreen() {
        navigationController?.pushViewController(userViewController, animated: true)
    }
}

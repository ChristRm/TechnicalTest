//
//  UserDefaults+TechnicalTest.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/4/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

extension UserDefaults {

    private struct Keys {
        static let dataGrabbed = "dataGrabbed"
    }

    // MARK: - Data grabbed

    class var dataGrabbed: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaults.Keys.dataGrabbed)
    }

    class func set(dataGrabbed: Bool) {
        UserDefaults.standard.set(dataGrabbed, forKey: UserDefaults.Keys.dataGrabbed)
    }
}

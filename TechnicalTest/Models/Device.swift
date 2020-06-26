//
//  Device.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

protocol Device {
    var id: Int { get set }
    var deviceName: String { get set }
    var productType: String { get set }
}

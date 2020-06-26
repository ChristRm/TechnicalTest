//
//  Shutter.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

class Shutter: Codable, Device {
    var id: Int
    var deviceName: String
    var productType: String

    var position: Int
}

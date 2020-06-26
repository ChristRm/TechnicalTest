//
//  Light.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

class Light: Codable {
    var id: Int
    var deviceName: String
    var productType: String
    
    var intensity: Int
    var mode: String
}

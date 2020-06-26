//
//  HomeData.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

class HomeData: Decodable {
    var devices: [Device] = []

    required init(from decoder: Decoder) throws {
        var container =
            try decoder.container(keyedBy: CodingKeys.self).nestedUnkeyedContainer(forKey: .devices)

        var devices = [Device]()
        while !container.isAtEnd {
            let itemContainer = try container.nestedContainer(keyedBy: CodingKeys.self)

            switch try itemContainer.decode(String.self, forKey: .productType) {
            case "heater": devices.append(try! Heater(from: itemContainer.superDecoder()))
            case "light": devices.append(try! Light(from: itemContainer.superDecoder()))
            case "shutter": devices.append(try! Shutter(from: itemContainer.superDecoder()))
            default: fatalError("Unknown type")
            }
        }

        self.devices = devices
        self.user = try! User(from: decoder)
    }

    var user: User

    private enum CodingKeys: String, CodingKey {
        case devices
        case user
        case productType
    }
}

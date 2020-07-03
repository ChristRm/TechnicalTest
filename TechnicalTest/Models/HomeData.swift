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
    var user: User
}

enum Device: Decodable {
    case light(Light)
    case heater(Heater)
    case shutter(Shutter)
    case unkonwn

    private enum CodingKeys: String, CodingKey {
        case productType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let productType = try container.decode(String.self, forKey: .productType)

        switch productType {
        case "Light":
            self = .light(try Light(from: decoder))
        case "Heater":
            self = .heater(try Heater(from: decoder))
        case "RollerShutter":
            self = .shutter(try Shutter(from: decoder))
        default:
            self = .unkonwn
        }
    }
}

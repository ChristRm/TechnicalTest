//
//  Light.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

final class Light: ManagedObject, Decodable, DeviceProtocol {

    @NSManaged var id: Int
    @NSManaged var deviceName: String
    @NSManaged var productType: String
    
    @NSManaged var intensity: Int
    @NSManaged var mode: String

    enum CodingKeys: String, CodingKey {
        case id
        case deviceName
        case productType
        case intensity
        case mode
    }

    public convenience init(from decoder: Decoder) throws {
        self.init(isInserted: false)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.deviceName = try container.decode(String.self, forKey: .deviceName)
        self.productType = try container.decode(String.self, forKey: .productType)
        self.intensity = try container.decode(Int.self, forKey: .intensity)
        self.mode = try container.decode(String.self, forKey: .mode)

        persist()
    }
}

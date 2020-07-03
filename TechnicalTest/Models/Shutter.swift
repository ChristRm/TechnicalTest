//
//  Shutter.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

final class Shutter: ManagedObject, Decodable, DeviceProtocol {

    @NSManaged var id: Int
    @NSManaged var deviceName: String
    @NSManaged var productType: String

    @NSManaged var position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case deviceName
        case productType
        case position
    }

    public convenience init(from decoder: Decoder) throws {
        self.init(isInserted: false)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.deviceName = try container.decode(String.self, forKey: .deviceName)
        self.productType = try container.decode(String.self, forKey: .productType)
        self.position = try container.decode(Int.self, forKey: .position)

        persist()
    }
}

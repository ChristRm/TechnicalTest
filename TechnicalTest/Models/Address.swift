//
//  Address.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

final class Address: ManagedObject, Decodable {

    @NSManaged var city: String
    @NSManaged var postalCode: Int
    @NSManaged var street: String
    @NSManaged var streetCode: String
    @NSManaged var country: String

    enum CodingKeys: String, CodingKey {
        case city
        case postalCode
        case street
        case streetCode
        case country
    }

    public convenience init(from decoder: Decoder) throws {
        self.init(isInserted: false)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(String.self, forKey: .city)
        self.postalCode = try container.decode(Int.self, forKey: .postalCode)
        self.street = try container.decode(String.self, forKey: .street)
        self.streetCode = try container.decode(String.self, forKey: .streetCode)
        self.country = try container.decode(String.self, forKey: .country)
    }
}

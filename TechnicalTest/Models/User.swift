//
//  User.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

final class User: ManagedObject, Decodable {

    @NSManaged public var birthDate: Date
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var address: Address

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case birthDate

        case address
    }

    public convenience init(from decoder: Decoder) throws {
        self.init(isInserted: false)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        let birthDateTimestamp = try! container.decode(Int.self, forKey: .birthDate)
        self.birthDate = Date(timeIntervalSince1970: Double(birthDateTimestamp))

        self.address = try container.decode(Address.self, forKey: .address)

        persist()
    }
}

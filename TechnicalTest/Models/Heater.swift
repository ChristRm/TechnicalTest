//
//  Heater.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

final class Heater: ManagedObject {
    @NSManaged var id: Int
    @NSManaged var deviceName: String
    @NSManaged var productType: String

    @NSManaged var mode: String
    @NSManaged var temperature: Int

//    required convenience init(from decoder: Decoder) throws {
//        self.in
//    }
}

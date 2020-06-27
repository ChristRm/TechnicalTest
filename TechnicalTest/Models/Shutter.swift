//
//  Shutter.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

final class Shutter: ManagedObject {// NSManagedObject, Codable {
    @NSManaged var id: Int
    @NSManaged var deviceName: String
    @NSManaged var productType: String

    @NSManaged var position: Int
}

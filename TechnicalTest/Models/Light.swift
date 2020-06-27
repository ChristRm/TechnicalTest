//
//  Light.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

final class Light: ManagedObject {//: NSManagedObject, Codable {
    @NSManaged var id: Int
    @NSManaged var deviceName: String
    @NSManaged var productType: String
    
    @NSManaged var intensity: Int
    @NSManaged var mode: String
}

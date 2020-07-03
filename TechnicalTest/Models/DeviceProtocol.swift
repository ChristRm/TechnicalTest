//
//  DeviceProtocol.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/1/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData

protocol DeviceProtocol {
    var id: Int { get set }
    var deviceName: String { get set }
    var productType: String { get set }

}

extension DeviceProtocol where Self: ManagedObject {

    static func fetchRequest() -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return fetchRequest
    }
}

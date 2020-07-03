//
//  ManagedObject.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import CoreData
import UIKit

class ManagedObject: NSManagedObject, CoreDataModel {

    // MARK: - Initializers
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init(isInserted: Bool = false) {

        let context =  type(of: self).coreDataStack.managedObjectContext
        let entityName = type(of: self).entityName
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { fatalError() }

        if isInserted {
            super.init(entity: entity, insertInto: context)
        } else {
            super.init(entity: entity, insertInto: nil)
        }
    }
    
    // MARK: - Class Methods
    
    class func fetchRequest<Model: ManagedObject>() -> NSFetchRequest<Model> {
        let fetchRequest = NSFetchRequest<Model>(entityName: entityName)

        #warning("sort descriptor move somewhere")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return fetchRequest
    }
    
    // MARK: - Public Methods
    
    func persist() {
        guard self.managedObjectContext == nil else { return }

        let context =  type(of: self).coreDataStack.managedObjectContext
        context.insert(self)
    }
    
    func delete() {
        guard let context = managedObjectContext else { return }
        context.delete(self)
    }
}

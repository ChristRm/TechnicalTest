//
//  CoreDataStack.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataStack {
    
    // MARK: - Properties
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = { [weak self] in
        guard let strongSelf = self else {fatalError("managedObjectContext error")}
        let coordinator = strongSelf.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "TechnicalTest", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { [weak self] in
        guard let strongSelf = self else {fatalError("persistentStoreCoordinator error")}
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: strongSelf.managedObjectModel)
        let url = strongSelf.applicationDocumentsDirectory.appendingPathComponent("TechnicalTest.sqlite")
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            print("Failed to initialize the application's saved data")
        }
        
        return coordinator
    }()
    
    // MARK: - Initializers
    
    init() {
        saveContext()
        
        print("Core Data: application directory is \(applicationDocumentsDirectory.absoluteString)")
    }
    
    // MARK: - Public Methods
    
    func delete<Object: NSManagedObject>(object: Object) {
        managedObjectContext.delete(object)
    }
    
    func delete<Object: NSManagedObject>(objects: [Object]) {
        objects.forEach { self.delete(object: $0) }
    }
    
    func delete<Object: CoreDataModel>(entitiesOfType type: Object.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
        
        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for fetchResult in fetchResults {
                    managedObjectContext.delete(fetchResult)
                }
            }
        } catch {
            fatalError(String(describing: error))
        }
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Core Data: failed to save the managed object context. An error has ocurred: \n\t\(error)")
            }
        } else {
            print("Saving context with no changing")
        }
    }
    
    func rollBack() {
        managedObjectContext.rollback()
    }
    
    func dropDatabase() {
        delete(entitiesOfType: User.self)
        delete(entitiesOfType: Heater.self)
        delete(entitiesOfType: Light.self)
        delete(entitiesOfType: Shutter.self)
        saveContext()
    }
}

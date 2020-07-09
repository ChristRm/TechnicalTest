//
//  XCTestCase.swift
//  TechnicalTestTests
//
//  Created by Chris Rusin on 7/8/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import XCTest
import CoreData
@testable import TechnicalTest

extension XCTestCase {

    // MARK: - Core Data

    static func mockCoreDataStack() -> CoreDataStack {
        let coreDataStack = CoreDataStack()

        // Initialize Mock Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: coreDataStack.managedObjectModel)

        // Add The Persistent Store of memory type specifically for Unit testing purposes
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

        coreDataStack.persistentStoreCoordinator = persistentStoreCoordinator

        return coreDataStack
    }

}

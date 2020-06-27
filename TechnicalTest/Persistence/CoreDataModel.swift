//
//  CoreDataModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataModel {
    
    static var coreDataStack: CoreDataStack { get }
    static var entityName: String { get }
    static var templateName: String { get }
}

extension CoreDataModel {

    static var coreDataStack: CoreDataStack {
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    }
    
    static var entityName: String {
        return String(describing: self)
    }
    
    static var templateName: String {
        return String(describing: self)
    }
}


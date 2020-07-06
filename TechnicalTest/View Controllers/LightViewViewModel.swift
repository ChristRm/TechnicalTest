//
//  LightViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift

class LightViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    private let coreDataStack: CoreDataStack

    private var light: Light?

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func start() {
        coreDataStack.managedObjectContext.performAndWait { [weak self] in
            do {
                let lights = try Light.fetchRequest().execute()
                self?.light = lights.first as? Light
            } catch {

            }
        }
    }

}

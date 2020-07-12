//
//  ShutterViewViewModelTest.swift
//  TechnicalTestTests
//
//  Created by Chris Rusin on 7/10/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import XCTest
import RxSwift
import RxCoreData
@testable import TechnicalTest

class ShutterViewViewModelTest: XCTestCase {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // Add The Persistent Store of memory type specifically for Unit testing purposes
    var coreDataStack: CoreDataStack!

    override func setUp() {
        coreDataStack = CoreDataStack(persistInMemory: true)
    }

    override func tearDown() {
        coreDataStack = nil
    }

    func test_level_is_stored() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let shutter = Shutter(context: coreDataStack.managedObjectContext)

        shutter.deviceName = "Mock shutter"
        shutter.productType = "Shutter"
        shutter.id = 1000
        shutter.position = 7

        var levelChanged = false
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Shutter.fetchRequest()).subscribe(onNext: { heaters in
                if let shutter = heaters.first(where: { $0.id == shutter.id }) {

                    levelChanged = shutter.position == 15
                    if levelChanged {
                        expectation.fulfill()
                    }

                } else {
                    XCTAssertTrue(true, "Shutter object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let shutterViewViewModel = ShutterViewViewModel(coreDataStack: coreDataStack, shutter: shutter)
        shutterViewViewModel.start()

        // set light on
        shutterViewViewModel.level.accept(15)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertTrue(levelChanged, "Position change has not been stored")
    }

    func test_level_greater_than_orEqual_0() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let shutter = Shutter(context: coreDataStack.managedObjectContext)

        shutter.deviceName = "Mock shutter"
        shutter.productType = "Shutter"
        shutter.id = 1000
        shutter.position = 7

        var updatedLevel: Int = -1
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Shutter.fetchRequest()).subscribe(onNext: { shutters in
                if let shutter = shutters.first(where: { $0.id == shutter.id }) {
                    updatedLevel = shutter.position
                    if updatedLevel >= 0 {
                        expectation.fulfill()
                    }
                } else {
                    XCTAssertTrue(true, "Shutter object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let shutterViewViewModel = ShutterViewViewModel(coreDataStack: coreDataStack, shutter: shutter)
        shutterViewViewModel.start()

        // set temperature
        shutterViewViewModel.level.accept(-1)

        wait(for: [expectation], timeout: 2.0)

        XCTAssertGreaterThanOrEqual(
            updatedLevel, 0,
            "Position cannot be greater than 0, validation had failed"
        )
    }

    func test_level_less_than_orEqual_100() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let shutter = Shutter(context: coreDataStack.managedObjectContext)

        shutter.deviceName = "Mock shutter"
        shutter.productType = "Shutter"
        shutter.id = 1000
        shutter.position = 7

        var updatedLevel: Int = 0
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Shutter.fetchRequest()).subscribe(onNext: { shutters in
                if let shutter = shutters.first(where: { $0.id == shutter.id }) {
                    updatedLevel = shutter.position
                    if updatedLevel <= 100 {
                        expectation.fulfill()
                    }
                } else {
                    XCTAssertTrue(true, "Shutter object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let shutterViewViewModel = ShutterViewViewModel(coreDataStack: coreDataStack, shutter: shutter)
        shutterViewViewModel.start()

        shutterViewViewModel.level.accept(101)

        wait(for: [expectation], timeout: 2.0)

        XCTAssertLessThanOrEqual(
            updatedLevel, 100,
            "Position cannot be greater than 100, validation had failed"
        )
    }

}

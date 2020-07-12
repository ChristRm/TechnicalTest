//
//  HeaterViewViewModel.swift
//  TechnicalTestTests
//
//  Created by Chris Rusin on 7/10/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import XCTest
import RxSwift
import RxCoreData
@testable import TechnicalTest

class HeaterViewViewModelTest: XCTestCase {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    var coreDataStack: CoreDataStack!

    override func setUp() {
        coreDataStack = CoreDataStack(persistInMemory: true)
    }

    override func tearDown() {
        coreDataStack = nil
    }

    func test_mode_is_stored() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let heater = Heater(context: coreDataStack.managedObjectContext)

        heater.deviceName = "Mock heater"
        heater.productType = "Heater"
        heater.id = 1000
        heater.mode = "OFF"
        heater.temperature = 7.0

        var modeIsTrue = false
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Heater.fetchRequest()).subscribe(onNext: { heaters in
            if let heater = heaters.first(where: { $0.id == heater.id }) {

                modeIsTrue = heater.mode == "ON"
                if modeIsTrue {
                    expectation.fulfill()
                }

            } else {
                XCTAssertTrue(true, "Heater object is not storred")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let heaterViewViewModel = HeaterViewViewModel(coreDataStack: coreDataStack, heater: heater)
        heaterViewViewModel.start()

        // set light on
        heaterViewViewModel.mode.accept(true)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertTrue(modeIsTrue, "Mode change has not been stored")
    }

    func test_temperature_is_stored() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let heater = Heater(context: coreDataStack.managedObjectContext)

        heater.deviceName = "Mock heater"
        heater.productType = "Heater"
        heater.id = 1000
        heater.mode = "OFF"
        heater.temperature = 7.0

        var temperatureChanged = false
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Heater.fetchRequest()).subscribe(onNext: { heaters in
                if let heater = heaters.first(where: { $0.id == heater.id }) {

                    temperatureChanged = heater.temperature == 15.0
                    if temperatureChanged {
                        expectation.fulfill()
                    }

                } else {
                    XCTAssertTrue(true, "Heater object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let heaterViewViewModel = HeaterViewViewModel(coreDataStack: coreDataStack, heater: heater)
        heaterViewViewModel.start()

        // set light on
        heaterViewViewModel.temperature.accept(15.0)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertTrue(temperatureChanged, "Mode change has not been stored")
    }

    func test_greater_than_orEqual_7() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let heater = Heater(context: coreDataStack.managedObjectContext)

        heater.deviceName = "Mock heater"
        heater.productType = "Heater"
        heater.id = 1000
        heater.mode = "OFF"
        heater.temperature = 0.0

        var updatedTemperature: Float = 0.0
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Heater.fetchRequest()).subscribe(onNext: { heaters in
                if let heater = heaters.first(where: { $0.id == heater.id }) {
                    updatedTemperature = heater.temperature
                    if updatedTemperature >= 7.0 {
                        expectation.fulfill()
                    }
                } else {
                    XCTAssertTrue(true, "Heater object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let heaterViewViewModel = HeaterViewViewModel(coreDataStack: coreDataStack, heater: heater)
        heaterViewViewModel.start()

        // set temperature
        heaterViewViewModel.temperature.accept(1.0)

        wait(for: [expectation], timeout: 2.0)

        XCTAssertGreaterThanOrEqual(
            updatedTemperature, 6.9999,
            file: "Temperature cannot be greater than 7.0, validation had failed"
        )
    }

    func test_temperature_less_than_orEqual_28() {
        let expectation =
            XCTestExpectation(description: "As the data is stored after some delay (logic implemented in viewModel) it makes sense to store")

        let heater = Heater(context: coreDataStack.managedObjectContext)

        heater.deviceName = "Mock heater"
        heater.productType = "Heater"
        heater.id = 1000
        heater.mode = "OFF"
        heater.temperature = 29.0

        var updatedTemperature: Float = 29.0
        coreDataStack.managedObjectContext.rx.entities(fetchRequest:
            Heater.fetchRequest()).subscribe(onNext: { heaters in
                if let heater = heaters.first(where: { $0.id == heater.id }) {
                    updatedTemperature = heater.temperature
                    if updatedTemperature <= 28.0 {
                        expectation.fulfill()
                    }
                } else {
                    XCTAssertTrue(true, "Heater object is not storred")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let heaterViewViewModel = HeaterViewViewModel(coreDataStack: coreDataStack, heater: heater)
        heaterViewViewModel.start()

        heaterViewViewModel.temperature.accept(29.0)

        wait(for: [expectation], timeout: 2.0)

        XCTAssertLessThanOrEqual(
            updatedTemperature, 28.00001,
            "Temperature cannot be greater than 7.0, validation had failed"
        )
    }
}

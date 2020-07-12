//
//  LightViewViewModelTest.swift
//  TechnicalTestTests
//
//  Created by Chris Rusin on 7/8/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import XCTest
import RxSwift
import RxCoreData
@testable import TechnicalTest

class LightViewViewModelTest: XCTestCase {

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
    
    func test_SetModeOn() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "OFF"
        light.intensity = 0

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var modeSwitched = false
        lightViewViewModel.mode.asObservable().subscribe(onNext: { mode in
            modeSwitched = mode
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputMode.accept(true)

        XCTAssertTrue(modeSwitched, "Output mode haven't been switched after switching the input binding")
    }

    func test_SetIntensity() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "OFF"
        light.intensity = 0

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var intensityChanged = false
        lightViewViewModel.intensity.asObservable().subscribe(onNext: { intensity in
            intensityChanged = intensity != 0
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputIntensity.accept(50)

        XCTAssertTrue(intensityChanged, "Output intensity haven't been switched after switching the input binding")
    }

    func test_SetModeOn_IntensityIsNotZero() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "OFF"
        light.intensity = 0

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var intensityChanged = false
        lightViewViewModel.intensity.asObservable().subscribe(onNext: { intensity in
            intensityChanged = intensity > 0
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputMode.accept(true)

        XCTAssertTrue(intensityChanged, "Output intensity remains 0 even after switching the input mode binding to true")
    }

    func test_SetModeOff_inetnsityIsZero() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "ON"
        light.intensity = 50

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var intensityChanged = false
        lightViewViewModel.intensity.asObservable().subscribe(onNext: { intensity in
            intensityChanged = intensity == 0
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputMode.accept(false)

        XCTAssertTrue(intensityChanged, "Output intensity remains > 0 even after switching the input mode binding to false")
    }

    func test_setIntensity50_modeOn() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "OFF"
        light.intensity = 0

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var modeSwitched = false
        lightViewViewModel.mode.asObservable().subscribe(onNext: { mode in
            modeSwitched = mode
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputIntensity.accept(50)

        XCTAssertTrue(modeSwitched, "Output mode haven't been switched from 'OFF' to 'ON' after switching the input intensity binding had been set to 50")
    }

    func test_setIntensity0_modeOff() {
        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1
        light.mode = "ON"
        light.intensity = 100

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        var modeSwitched = false
        lightViewViewModel.mode.asObservable().subscribe(onNext: { mode in
            modeSwitched = mode == false
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // set light on
        lightViewViewModel.inputIntensity.accept(0)

        XCTAssertTrue(modeSwitched, "Output mode haven't been switched from 'ON' to 'OFF' after switching the input intensity binding had been set to 0")
    }

    func test_mode_is_stored() {
        let expectation =
            XCTestExpectation(description: "As the data is stored with some delay (logic implemented in viewModel) it makes sense to store")

        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1000
        light.mode = "OFF"
        light.intensity = 0

        var modeIsTrue = false
        coreDataStack.managedObjectContext.rx.entities(fetchRequest: Light.fetchRequest()).subscribe(onNext: { lights in
            if let light = lights.first(where: { $0.id == light.id }) {

                modeIsTrue = light.mode == "ON"
                if modeIsTrue {
                    expectation.fulfill()
                }

            } else {
                XCTAssertTrue(true, "Light object is not storred")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        // set light on
        lightViewViewModel.inputMode.accept(true)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertTrue(modeIsTrue, "Mode change has not been stored")
    }

    func test_intensity_is_stored() {
        let expectation =
            XCTestExpectation(description: "As the data is stored with some delay (logic implemented in viewModel) it makes sense to store")

        let light = Light(context: coreDataStack.managedObjectContext)

        light.deviceName = "Mock light"
        light.productType = "Light"
        light.id = 1000
        light.mode = "OFF"
        light.intensity = 0

        var intensityIsGreaterThan0 = false
        coreDataStack.managedObjectContext.rx.entities(fetchRequest: Light.fetchRequest()).subscribe(onNext: { lights in
            if let light = lights.first(where: { $0.id == light.id }) {

                intensityIsGreaterThan0 = light.intensity > 0
                if intensityIsGreaterThan0 {
                    expectation.fulfill()
                }

            } else {
                XCTAssertTrue(true, "Light object is not storred")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
        lightViewViewModel.start()

        // set light on
        lightViewViewModel.inputMode.accept(true)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertTrue(intensityIsGreaterThan0, "Mode change has not been stored")
    }
}

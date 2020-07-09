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

    let coreDataStack: CoreDataStack = XCTestCase.mockCoreDataStack()

    override func setUp() {
    }

    func testSetOnOff() {
//        let light = Light(context: coreDataStack.managedObjectContext)
//
//        light.deviceName = "Mock light"
//        light.productType = "Light"
//        light.id = 1
//        light.mode = "OFF"
//        light.intensity = 0
//
//        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
//        lightViewViewModel.start()
//
//        var mode: String?
//        coreDataStack.managedObjectContext.rx.entities(fetchRequest: Light.fetchRequest()).asObservable().subscribe(onNext: { lights in
//            mode = lights.first(where: { $0.id == light.id })?.mode
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
//
//        // set light on
//        lightViewViewModel._mode.accept(true)
//
//        sleep(6)
//
//        XCTAssertEqual(mode, "ON")
    }

    func testIntensity() {
//        let light = Light(context: coreDataStack.managedObjectContext)
//
//        light.deviceName = "Mock light"
//        light.productType = "Light"
//        light.id = 1
//        light.mode = "OFF"
//        light.intensity = 0
//
//        let lightViewViewModel = LightViewViewModel(coreDataStack: coreDataStack, light: light)
//        lightViewViewModel.start()
//
//        var intensity: Int?
//        coreDataStack.managedObjectContext.rx.entities(fetchRequest: Light.fetchRequest())
//            .asObservable().subscribe(onNext: { lights in
//            intensity = lights.first(where: { $0.id == light.id })?.intensity
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
//
//        // set light on
//        lightViewViewModel._intensity.accept(50)
//
//        sleep(6)
//
//        XCTAssertEqual(intensity, 50)
    }

}

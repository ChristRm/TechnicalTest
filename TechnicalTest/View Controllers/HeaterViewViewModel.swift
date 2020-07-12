//
//  HeaterViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/7/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeaterViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    private let coreDataStack: CoreDataStack

    private var heater: Heater

    // MARK: - Input
    private(set) var mode: BehaviorRelay<Bool?> = BehaviorRelay<Bool?>(value: nil)
    private(set) var temperature: BehaviorRelay<Float?> = BehaviorRelay<Float?>(value: nil)

    init(coreDataStack: CoreDataStack, heater: Heater) {
        self.coreDataStack = coreDataStack
        self.heater = heater
        mode.accept(heater.mode == "ON")
        temperature.accept(heater.temperature)
    }

    func start() {
        mode.debounce(1.0, scheduler: MainScheduler.instance).subscribe({ [weak self] event in
            switch event {
            case .next(let on):
                self?.heater.mode = on == true ? "ON" : "OFF"
                self?.coreDataStack.saveContext()
            default:
                break
            }
        }).disposed(by: disposeBag)

        temperature.debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe({ [weak self] event in
            switch event {
            case .next(let temperature):
                var validatedTemperature = (temperature ?? 7.0)
                validatedTemperature = validatedTemperature >= 7.0 ? validatedTemperature : 7.0
                validatedTemperature = validatedTemperature <= 28.0 ? validatedTemperature : 28.0
                self?.heater.temperature = validatedTemperature
                self?.coreDataStack.saveContext()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}

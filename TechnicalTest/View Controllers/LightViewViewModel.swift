//
//  LightViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LightViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    private let coreDataStack: CoreDataStack

    private var light: Light

    // MARK: - Input
    private(set) var mode: BehaviorRelay<Bool?> = BehaviorRelay<Bool?>(value: nil)
    private(set) var intensity: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)

    init(coreDataStack: CoreDataStack, light: Light) {
        self.coreDataStack = coreDataStack
        self.light = light
        mode.accept(light.mode == "ON")
        intensity.accept(light.intensity)
    }

    func start() {
        mode.subscribe({ [weak self] event in
            switch event {
            case .next(let on):
                self?.light.mode = on == true ? "ON" : "OFF"
                self?.coreDataStack.saveContext()
            default:
                break
            }
        }).disposed(by: disposeBag)

        intensity.subscribe({ [weak self] event in
            switch event {
            case .next(let intensity):
                self?.light.intensity = intensity ?? 0
                self?.coreDataStack.saveContext()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

}
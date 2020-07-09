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

    private typealias ModeAndIntensity = (mode: Bool, intensity: Float)

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    private let coreDataStack: CoreDataStack

    private var light: Light

    // MARK: - Output
    var mode: Driver<Bool> { return _mode.asDriver() }
    var intensity: Driver<Float> { return _intensity.asDriver() }

    // MARK: - Input
    private(set) var inputMode: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private(set) var inputIntensity: BehaviorRelay<Float> = BehaviorRelay<Float>(value: 0.0)

    // MARK: - Private
    private let _mode: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private let _intensity: BehaviorRelay<Float> = BehaviorRelay<Float>(value: 0.0)

    init(coreDataStack: CoreDataStack, light: Light) {
        self.coreDataStack = coreDataStack
        self.light = light
        _mode.accept(light.mode == "ON")
        inputMode.accept(light.mode == "ON")
        _intensity.accept(Float(Float(light.intensity) / 100.0))
        inputIntensity.accept(Float(Float(light.intensity) / 100.0))
    }

    func start() {
        /// mode ON cannot correspont to intensity 0
        inputMode.map({ [weak self] mode -> Float in
            guard let weakSelf = self else { return 0.0 }

            if mode != weakSelf._mode.value {
                return Float(mode ? 1.0 : 0.0)
            } else {
                return weakSelf._intensity.value
            }
        }).bind(to: _intensity).disposed(by: disposeBag)

        inputMode.distinctUntilChanged().bind(to: _mode).disposed(by: disposeBag)

        /// intensity > 0 cannot correspond to mode OFF
        inputIntensity.map({ [weak self] level -> Bool in
            guard let weakSelf = self else { return false }

            if level != weakSelf._intensity.value {
                return Int(level * 100.0) > 0
            } else {
                return weakSelf._mode.value
            }
        }).bind(to: _mode).disposed(by: disposeBag)

        inputIntensity.distinctUntilChanged().bind(to: _intensity).disposed(by: disposeBag)

        /// once the values of mode and intensity are changed save them with the delay of 1 second
        /// after last change to avoid too frequent access to the storage
        let modeObservable: Observable<Bool> =
            mode.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
        let intensityObservable: Observable<Float> =
            intensity.asObservable().debounce(0.2, scheduler: MainScheduler.instance)

        Observable.zip(
            modeObservable,
            intensityObservable,
            resultSelector: { (mode: Bool, intensity: Float) -> ModeAndIntensity in
                return ModeAndIntensity(mode: mode, intensity: intensity)
        }).debounce(1.0, scheduler: MainScheduler.instance).subscribe({ [weak self] event in
                        switch event {
                        case .next(let modeAndIntensity):
                            self?.light.intensity = Int(modeAndIntensity.intensity * 100.0)
                            self?.light.mode = modeAndIntensity.mode ? "ON" : "OFF"
                            self?.coreDataStack.saveContext()
                        default:
                            break
                        }
                    }).disposed(by: disposeBag)
    }
}

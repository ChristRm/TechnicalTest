//
//  ShutterViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/7/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ShutterViewViewModel {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()
    private let coreDataStack: CoreDataStack
    private var shutter: Shutter

    // MARK: - Input
    private(set) var level: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)

    init(coreDataStack: CoreDataStack, shutter: Shutter) {
        self.coreDataStack = coreDataStack
        self.shutter = shutter
        level.accept(shutter.position)
    }

    func start() {
        level.distinctUntilChanged().subscribe({ [weak self] event in
            switch event {
            case .next(let level):
                self?.shutter.position = level ?? 0
                self?.coreDataStack.saveContext()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}

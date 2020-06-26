//
//  DashboardViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DashboardViewViewModel {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Output
    var employeesSections: Driver<[DevicesSection]> { return _devicesSections.asDriver() }

    // MARK: - Private properties

    private let _devicesSections = BehaviorRelay<[DevicesSection]>(value: [])

    func start() {
        TechnicalTestApi.getHomeData().map({ homeData -> [DevicesSection] in
            print(homeData)
            return []
        }).bind(to: _devicesSections).disposed(by: disposeBag)
    }
}

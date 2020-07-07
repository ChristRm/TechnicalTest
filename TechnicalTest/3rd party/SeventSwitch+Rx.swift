//
//  SeventSwitch+Rx.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/7/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: SevenSwitch {
    /// Reactive wrapper for `text` property.
    public var on: Observable<Bool?> {
        return observe(Bool.self, "switchValue")
    }
}

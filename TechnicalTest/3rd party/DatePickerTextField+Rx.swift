//
//  DatePickerTextField+rx.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: DatePickerTextField {
    /// Reactive wrapper for `text` property.
    public var date: Observable<NSDate?> {
        return observe(NSDate.self, "date")
    }
}

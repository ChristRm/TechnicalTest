//
//  SeventSwitch+Rx.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/7/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SevenSwitch {

    /// Reactive wrapper for `isOn` property.
    public var isOn: ControlProperty<Bool> {
        return value
    }

    /// Reactive wrapper for `isOn` property.
    ///
    /// ⚠️ Versions prior to iOS 10.2 were leaking `UISwitch`'s, so on those versions
    /// underlying observable sequence won't complete when nothing holds a strong reference
    /// to `UISwitch`.
    public var value: ControlProperty<Bool> {
        return UIControl.valuePublic(
            self.base,
            getter: { customControl in
                customControl.on
        }, setter: { customControl, value in
            customControl.on = value
        }
        )
    }
}

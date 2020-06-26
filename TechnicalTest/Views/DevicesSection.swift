//
//  DevicesSection.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxDataSources

struct DevicesSection: SectionModelType {
    typealias Item = DeviceCellModel

    var header: String
    var items: [Item]

    init(original: DevicesSection, items: [Item]) {
        self = original
        self.items = items
    }

    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

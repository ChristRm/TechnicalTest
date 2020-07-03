//
//  DeviceCellModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation

enum DeviceType {
    case heater
    case shutter
    case light
}

struct DeviceCellModel {
    let deviceType: DeviceType
    let title: String

    let onSelect: () -> ()
}

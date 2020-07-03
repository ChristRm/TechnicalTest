//
//  ReusableView.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit

protocol StaticReusableView {

    static var staticReuseIdentifier: String { get }

}

extension StaticReusableView {

    static var staticReuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: StaticReusableView {}
extension UICollectionReusableView: StaticReusableView {}



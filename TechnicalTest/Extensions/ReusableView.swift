//
//  ReusableView.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit

protocol ReusableView {

    static var staticReuseIdentifier: String { get }

}

extension ReusableView {

    static var staticReuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReusableView {}

extension UICollectionViewCell: ReusableView {}

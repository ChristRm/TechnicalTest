//
//  UICollectionView+dequeueReusableCell.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerReusableCell<T: UICollectionViewCell>(type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.staticReuseIdentifier)
    }

    func registerReusableHeader<T: UICollectionReusableView>(type: T.Type) {
        register(
            type,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.staticReuseIdentifier
        )
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.staticReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }

        return cell
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let reusableHeader = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.staticReuseIdentifier,
            for: indexPath
            ) as? T else {
                fatalError("Unable to Dequeue Reusable Table View Header")
        }

        return reusableHeader
    }

}


//
//  DevicesCollectionViewHeader.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/3/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit

class DevicesCollectionViewHeader: UICollectionReusableView {

    private let titleLabel: UILabel

    override init(frame: CGRect) {
        let titleLabel = UILabel(frame: .zero)

        self.titleLabel = titleLabel

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

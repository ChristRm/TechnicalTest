//
//  DeviceCell.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit

final class DeviceCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private var imageView: UIImageView?
    private var titleLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        self.imageView = imageView

        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true

        self.titleLabel = titleLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setModel(_ model: DeviceCellModel) {
        switch model.deviceType {
        case .heater:
            imageView?.image = UIImage(named: "radiator")
            break

        case .light:
            imageView?.image = UIImage(named: "lights")
            break

        case .shutter:
            imageView?.image = UIImage(named: "shutters")
            break
        }

        titleLabel?.text = model.title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor(hex: 0xdddddd, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = bounds.width * CGFloat(0.06)
    }
}

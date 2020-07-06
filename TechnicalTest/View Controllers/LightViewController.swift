//
//  LightViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxSwift

class LightViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    var viewModel: LightViewViewModel?

    // MARK: - Lifecycle
    override func loadView() {
        let rootView = UIView(frame: .zero)

        let lightSwitch = SevenSwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        lightSwitch.translatesAutoresizingMaskIntoConstraints = false

        lightSwitch.activeColor = .yellow
        lightSwitch.inactiveColor = .blue
        rootView.backgroundColor = UIColor(hex: 0xfffff8)
        rootView.addSubview(lightSwitch)

        lightSwitch.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        lightSwitch.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        lightSwitch.topAnchor.constraint(
            equalTo: rootView.topAnchor,
            constant: 100.0
            ).isActive = true

        lightSwitch.leadingAnchor.constraint(
            equalTo: rootView.leadingAnchor,
            constant: 100.0
            ).isActive = true

        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false

        rootView.backgroundColor = UIColor(hex: 0xfffff8)
        rootView.addSubview(slider)

        slider.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        slider.topAnchor.constraint(
            equalTo: rootView.topAnchor,
            constant: 150.0
            ).isActive = true

        slider.leadingAnchor.constraint(
            equalTo: rootView.leadingAnchor,
            constant: 100.0
            ).isActive = true

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Light"
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        }
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: LightViewViewModel) {
        
    }

    private func slider() {

    }
}

//
//  ShutterViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift

class ShutterViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    let levelLabel = UILabel(frame: .zero)
    let levelSlider = UISlider(frame: .zero)

    // MARK: - ViewModel
    var viewModel: ShutterViewViewModel?

    // MARK: - Lifecycle
    override func loadView() {
        let rootView = UIView(frame: .zero)
        rootView.backgroundColor = UIColor(hex: 0xfffff8)


        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "100%"

        rootView.addSubview(levelLabel)
        levelLabel.heightAnchor.constraint(equalToConstant: 15.0)
        levelLabel.textAlignment = .left

        levelLabel.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true

        levelLabel.topAnchor.constraint(
            equalTo: rootView.safeAreaLayoutGuide.topAnchor,
            constant: 20.0
            ).isActive = true

        levelLabel.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        levelSlider.translatesAutoresizingMaskIntoConstraints = false

        rootView.backgroundColor = UIColor(hex: 0xfffff8)
        rootView.addSubview(levelSlider)

        levelSlider.tintColor = .black
        levelSlider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        levelSlider.widthAnchor.constraint(equalToConstant: 300.0).isActive = true

        levelSlider.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        levelSlider.centerYAnchor.constraint(equalTo: rootView.centerYAnchor).isActive = true

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shutter"

        let trans = CGAffineTransform(rotationAngle: CGFloat(M_PI * -0.5))
        levelSlider.transform = trans
        if let viewModel = viewModel {
            bindViewModel(viewModel)
            viewModel.start()
        }
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: ShutterViewViewModel) {
        levelLabel.text = "\(viewModel.level.value ?? 0)"

        levelSlider.value = Float(viewModel.level.value ?? 0) / 100.0

        levelSlider.rx.value.map({ [weak self] sliderValue -> Int in
            let intValue = Int(sliderValue * 100.0)
            self?.levelLabel.text = "\(intValue) %"
            return intValue
        }).bind(to: viewModel.level)
            .disposed(by: disposeBag)
    }
}

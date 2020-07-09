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

    // MARK: - Properties
    let onOffLabel = UILabel(frame: .zero)
    let intensityLabel = UILabel(frame: .zero)
    let lightSwitch = SevenSwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    let intensitySlider = UISlider(frame: .zero)

    // MARK: - ViewModel
    var viewModel: LightViewViewModel?

    // MARK: - Lifecycle
    override func loadView() {
        let rootView = UIView(frame: .zero)
        rootView.backgroundColor = UIColor(hex: 0xfffff8)

        onOffLabel.translatesAutoresizingMaskIntoConstraints = false

        rootView.addSubview(onOffLabel)
        onOffLabel.heightAnchor.constraint(equalToConstant: 15.0)
        onOffLabel.textAlignment = .right

        onOffLabel.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true

        onOffLabel.topAnchor.constraint(
            equalTo: rootView.safeAreaLayoutGuide.topAnchor,
            constant: 20.0
            ).isActive = true

        onOffLabel.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        lightSwitch.translatesAutoresizingMaskIntoConstraints = false

        lightSwitch.inactiveColor = .darkText
        lightSwitch.onTintColor = .yellow

        rootView.addSubview(lightSwitch)

        lightSwitch.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        lightSwitch.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        lightSwitch.topAnchor.constraint(
            equalTo: onOffLabel.bottomAnchor,
            constant: 10.0
            ).isActive = true

        lightSwitch.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        intensityLabel.translatesAutoresizingMaskIntoConstraints = false

        rootView.addSubview(intensityLabel)
        intensityLabel.heightAnchor.constraint(equalToConstant: 15.0)
        intensityLabel.textAlignment = .right

        intensityLabel.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true

        intensityLabel.topAnchor.constraint(
            equalTo: lightSwitch.bottomAnchor,
            constant: 10.0
            ).isActive = true

        intensityLabel.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        intensitySlider.translatesAutoresizingMaskIntoConstraints = false

        rootView.backgroundColor = UIColor(hex: 0xfffff8)
        rootView.addSubview(intensitySlider)

        intensitySlider.tintColor = .yellow
        intensitySlider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        intensitySlider.topAnchor.constraint(
            equalTo: intensityLabel.bottomAnchor,
            constant: 10.0
            ).isActive = true

        intensitySlider.leadingAnchor.constraint(
            equalTo: rootView.leadingAnchor,
            constant: 20.0
            ).isActive = true

        intensitySlider.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Light"
        if let viewModel = viewModel {
            bindViewModel(viewModel)
            viewModel.start()
        }
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: LightViewViewModel) {
//        onOffLabel.text = viewModel._mode.value == true ? "ON" : "OFF"
//        intensityLabel.text = "\(viewModel._intensity.value ?? 0)"

//        lightSwitch.on = viewModel._mode.value == true
//        lightSwitch.rx.isOn.bind(to: viewModel._mode).disposed(by: disposeBag)
        viewModel.mode.drive(lightSwitch.rx.isOn).disposed(by: disposeBag)
        viewModel.intensity.drive(intensitySlider.rx.value).disposed(by: disposeBag)

        viewModel.mode.map({ $0 ? "ON" : "OFF" }).drive(onOffLabel.rx.text).disposed(by: disposeBag)
        viewModel.intensity.map({ "\(Int($0 * Float(100.0)))" }).drive(intensityLabel.rx.text).disposed(by: disposeBag)

        lightSwitch.rx.isOn.bind(to: viewModel.inputMode).disposed(by: disposeBag)
        intensitySlider.rx.value.bind(to: viewModel.inputIntensity).disposed(by: disposeBag)
//        intensitySlider.value = Float(viewModel._intensity.value ?? 0) / 100.0

//        intensitySlider.rx.value.map({ [weak self] sliderValue -> Int in
//            let intValue = Int(sliderValue * 100.0)
//            self?.intensityLabel.text = "\(intValue)"
//            return intValue
//        }).debounce(1.0, scheduler: MainScheduler.instance)
//            .bind(to: viewModel._intensity)
//            .disposed(by: disposeBag)

//        lightSwitch.rx.isOn.debounce(1.0, scheduler: MainScheduler)
//        lightSwitch.rx.isOn.bind(to: viewModel._intensity)

//        lightSwitch.rx.on.debounce(1.0, scheduler: MainScheduler.instance)
//            .bind(to: viewModel._mode).disposed(by: disposeBag)
//
//        lightSwitch.rx.on
//            .subscribe(onNext: { [weak self] on in
//                self?.onOffLabel.text = on == true ? "ON" : "OFF"
//                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

//
//  HeaterViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/6/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift

class HeaterViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Properties
    let onOffLabel = UILabel(frame: .zero)
    let temperatureLabel = UILabel(frame: .zero)
    let temperatureSwitch = SevenSwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    let temperatureSlider = UISlider(frame: .zero)

    // MARK: - ViewModel
    var viewModel: HeaterViewViewModel?

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

        temperatureSwitch.translatesAutoresizingMaskIntoConstraints = false

        temperatureSwitch.inactiveColor = .darkText
        temperatureSwitch.onTintColor = .orange

        rootView.addSubview(temperatureSwitch)

        temperatureSwitch.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        temperatureSwitch.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        temperatureSwitch.topAnchor.constraint(
            equalTo: onOffLabel.bottomAnchor,
            constant: 10.0
            ).isActive = true

        temperatureSwitch.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        rootView.addSubview(temperatureLabel)
        temperatureLabel.heightAnchor.constraint(equalToConstant: 15.0)
        temperatureLabel.textAlignment = .right

        temperatureLabel.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true

        temperatureLabel.topAnchor.constraint(
            equalTo: temperatureSwitch.bottomAnchor,
            constant: 10.0
            ).isActive = true

        temperatureLabel.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        temperatureSlider.translatesAutoresizingMaskIntoConstraints = false

        rootView.backgroundColor = UIColor(hex: 0xfffff8)
        rootView.addSubview(temperatureSlider)

        temperatureSlider.tintColor = .orange
        temperatureSlider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        temperatureSlider.topAnchor.constraint(
            equalTo: temperatureLabel.bottomAnchor,
            constant: 10.0
            ).isActive = true

        temperatureSlider.leadingAnchor.constraint(
            equalTo: rootView.leadingAnchor,
            constant: 20.0
            ).isActive = true

        temperatureSlider.trailingAnchor.constraint(
            equalTo: rootView.trailingAnchor,
            constant: -20.0
            ).isActive = true

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heater"
        if let viewModel = viewModel {
            bindViewModel(viewModel)
            viewModel.start()
        }
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: HeaterViewViewModel) {
        onOffLabel.text = viewModel.mode.value == true ? "ON" : "OFF"
        temperatureLabel.text = "\(viewModel.temperature.value ?? 0)°"

        temperatureSwitch.on = viewModel.mode.value == true
        temperatureSlider.value = Float(viewModel.temperature.value ?? 0) / 100.0

        temperatureSlider.rx.value.map({ [weak self] sliderValue -> Float in
            let value = self?.calculateTemperature(sliderValue: sliderValue) ?? 7.0
            self?.temperatureLabel.text = "\(value)°"
            return value
        }).debounce(1.0, scheduler: MainScheduler.instance)
            .bind(to: viewModel.temperature)
            .disposed(by: disposeBag)

        temperatureSwitch.rx.isOn.debounce(1.0, scheduler: MainScheduler.instance)
            .bind(to: viewModel.mode).disposed(by: disposeBag)

        temperatureSwitch.rx.isOn
            .subscribe(onNext: { [weak self] on in
                self?.onOffLabel.text = on == true ? "ON" : "OFF"
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    private func calculateTemperature(sliderValue: Float) -> Float {
        let minValue: Float = 7.0
        let maxValue: Float = 28.0

        let temoerature = minValue + (maxValue - minValue) * sliderValue

        return temoerature.round(nearest: 0.5)
    }

    private func calculateSliderValue(temperature: Float) -> Float {
        let minValue: Float = 7.0
        let maxValue: Float = 28.0

        return minValue + (maxValue - minValue) * temperature
    }
}

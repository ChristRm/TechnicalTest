//
//  UserViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/4/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Properties

    private let stackView: UIStackView = UIStackView(frame: .zero)
    private let contentScrollView = UIScrollView(frame: .zero)

    private var userNameTextField: UITextField?
    private var userLastNameTextField: UITextField?

    private var userBirthDateTextField: DatePickerTextField?

    private var userCityTextField: UITextField?
    private var userCountryTextField: UITextField?
    private var userStreetTextField: UITextField?
    private var userStreetCodeTextField: UITextField?

    // MARK: - ViewModel
    var viewModel: UserViewViewModel?

    // MARK: - Lifecycle
    override func loadView() {
        let rootView = UIView(frame: .zero)

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false

        rootView.addSubview(contentScrollView)
        rootView.backgroundColor = UIColor(hex: 0xfffff8)

        contentScrollView.backgroundColor = .clear
        contentScrollView.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: rootView.rightAnchor).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false

        addLabel(title: "Name: ")
        userNameTextField = addTextField()
        addLabel(title: "Last name: ")
        userLastNameTextField = addTextField()
        addLabel(title: "Birth date: ")
        userBirthDateTextField = addDatePickerTextField()

        addLabel(title: "City: ")
        userCityTextField = addTextField()
        addLabel(title: "Country: ")
        userCountryTextField = addTextField()
        addLabel(title: "Street: ")
        userStreetTextField = addTextField()
        addLabel(title: "Street code: ")
        userStreetCodeTextField = addTextField()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 2

        contentScrollView.addSubview(stackView)

        stackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor).isActive = true
        contentScrollView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User"

        let button =
            UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)

        button.rx.tap.subscribe({ [weak self] tapped in
            switch tapped {
            case .next(_):
                self?.stackView.arrangedSubviews.forEach({ arrangedSubview in
                    arrangedSubview.resignFirstResponder()
                })
                self?.viewModel?.save()
                break
            default:
                break
            }
        }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem  = button

        if let viewModel = viewModel {
            viewModel.start()
            bindViewModel(viewModel)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }

    // MARK: - Private methods

    private func bindViewModel(_ viewModel: UserViewViewModel) {
        userNameTextField?.text = viewModel.name.value
        userLastNameTextField?.text = viewModel.lastName.value

        userBirthDateTextField?.text =
            NSDate(timeIntervalSince1970:
                viewModel.birthDate.value?.timeIntervalSince1970 ?? 0.0).yearMonthDayString()

        userCityTextField?.text = viewModel.city.value
        userCountryTextField?.text = viewModel.country.value
        userStreetTextField?.text = viewModel.street.value
        userStreetCodeTextField?.text = viewModel.streetCode.value

        userNameTextField?.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: viewModel.name)
            .disposed(by: disposeBag)

        userLastNameTextField?.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: viewModel.lastName)
            .disposed(by: disposeBag)

        userBirthDateTextField?.rx.date.map({ nsDate in
            return nsDate as Date?
        }).bind(to: viewModel.birthDate)
        .disposed(by: disposeBag)

        userBirthDateTextField?.rx.text
            .asObservable().map({ [weak self] _ -> Date in
                return self?.userBirthDateTextField?.date ?? Date()
            }).bind(to: viewModel.birthDate).disposed(by: disposeBag)

        userCityTextField?.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: viewModel.city)
            .disposed(by: disposeBag)

        userCountryTextField?.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: viewModel.country)
            .disposed(by: disposeBag)

        userStreetTextField?.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: viewModel.street)
            .disposed(by: disposeBag)
    }

    private func addTextField() -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 30.0))

        textField.layer.borderColor = UIColor(hex: 0xf2f2f2).cgColor
        textField.layer.borderWidth = 1.0

        textField.heightAnchor.constraint(equalToConstant: 45.0).isActive = true

        stackView.addArrangedSubview(textField)

        textField.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true

        return textField
    }

    func addDatePickerTextField() -> DatePickerTextField {
        let datePickerTextField = DatePickerTextField()

        datePickerTextField.type = .yearMonthDay
        datePickerTextField.rangeType = .before

        datePickerTextField.layer.borderColor = UIColor(hex: 0xf2f2f2).cgColor
        datePickerTextField.layer.borderWidth = 1.0

        datePickerTextField.heightAnchor.constraint(equalToConstant: 45.0).isActive = true

        stackView.addArrangedSubview(datePickerTextField)

        datePickerTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        datePickerTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true

        return datePickerTextField
    }

    private func addLabel(title: String) {
        let label = UILabel(frame: .zero)
        label.heightAnchor.constraint(equalToConstant: 15.0)
        label.textAlignment = .left
        label.text = title

        stackView.addArrangedSubview(label)

        label.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true

        stackView.addArrangedSubview(label)
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        contentScrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        contentScrollView.contentInset.bottom = 0
    }
}

//
//  UserViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 7/4/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class UserViewViewModel {

    private let disposeBag = DisposeBag()

    // MARK: - Input

    private(set) var name: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private(set) var lastName: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)

    private(set) var birthDate: BehaviorRelay<Date?> = BehaviorRelay<Date?>(value: nil)

    private(set) var city: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private(set) var country: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private(set) var street: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private(set) var streetCode: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)

    // MARK: - Private properties

    private let _devicesSections = BehaviorRelay<[DevicesSection]>(value: [])

    private let coreDataStack: CoreDataStack
    private var user: User? = nil {
        didSet {
            name.accept(user?.firstName)
            lastName.accept(user?.lastName)
            birthDate.accept(user?.birthDate)

            city.accept(user?.address.city)
            country.accept(user?.address.country)
            street.accept(user?.address.street)
            streetCode.accept(user?.address.streetCode)
        }
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func start() {
        coreDataStack.managedObjectContext.performAndWait { [weak self] in
            do {
                let users = try User.fetchRequest().execute()
                self?.user = users.first as? User
            } catch {

            }
        }
    }

    func save() {
        user?.firstName = name.value ?? ""
        user?.lastName = lastName.value ?? ""
        user?.birthDate = birthDate.value ?? Date(timeIntervalSince1970: 0.0)

        user?.address.city = city.value ?? ""
        user?.address.country = country.value ?? ""
        user?.address.street = street.value ?? ""
        user?.address.streetCode = streetCode.value ?? ""

        coreDataStack.saveContext()
    }
}

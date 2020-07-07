//
//  DashboardViewViewModel.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/26/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import RxCoreData

final class DashboardViewViewModel {

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    var userViewViewModel: UserViewViewModel {
        return UserViewViewModel(coreDataStack: coreDataStack)
    }

    var lightViewViewModel: LightViewViewModel {
        return LightViewViewModel(coreDataStack: coreDataStack, light: _selectedLight.value!)
    }

    var shutterViewViewModel: ShutterViewViewModel {
        return ShutterViewViewModel(coreDataStack: coreDataStack, shutter: _selectedShutter.value!)
    }

    var heaterViewViewModel: HeaterViewViewModel {
        return HeaterViewViewModel(coreDataStack: coreDataStack, heater: _selectedHeater.value!)
    }

    // MARK: - Output
    var devicesSections: Driver<[DevicesSection]> { return _devicesSections.asDriver() }
    var confirmDeviceRemoval: Observable<(() -> Void)?> { return _confirmDeviceRemoval.asObservable() }

    var selectedLight: Observable<Light?> { return _selectedLight.asObservable() }
    var selectedShutter: Observable<Shutter?> { return _selectedShutter.asObservable() }
    var selectedHeater: Observable<Heater?> { return _selectedHeater.asObservable() }

    // MARK: - Private properties

    private let _devicesSections = BehaviorRelay<[DevicesSection]>(value: [])
    private let _confirmDeviceRemoval = BehaviorRelay<(() -> Void)?>(value: nil)

    private let _selectedLight = BehaviorRelay<Light?>(value: nil)
    private let _selectedShutter = BehaviorRelay<Shutter?>(value: nil)
    private let _selectedHeater = BehaviorRelay<Heater?>(value: nil)

    private let coreDataStack: CoreDataStack
    private var managedObjectContext: NSManagedObjectContext {
        return coreDataStack.managedObjectContext
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func start() {
        if UserDefaults.dataGrabbed {
            self.subscribeOnUpdates()
        } else {
            TechnicalTestApi.getHomeData().map({ homeData -> [DevicesSection] in
                return []
            }).subscribe({ [weak self] event in
                switch event {
                case .completed:
                    self?.coreDataStack.saveContext()
                    self?.subscribeOnUpdates()
                    break
                case .next(_):
                    break
                case .error(_):
                    break
                }
            }).disposed(by: disposeBag)
        }
    }

    // MARK: - Private methods

    private func subscribeOnUpdates() {
        let heatersObservable = managedObjectContext.rx.entities(fetchRequest: Heater.fetchRequest())
        let lightsObservable = managedObjectContext.rx.entities(fetchRequest: Light.fetchRequest())
        let shuttersObservable = managedObjectContext.rx.entities(fetchRequest: Shutter.fetchRequest())

        Observable.combineLatest(
            heatersObservable,
            lightsObservable,
            shuttersObservable,
            resultSelector: { (heaters, lights, shutters) -> [DevicesSection] in
                let lightsSection = DevicesSection(
                    header: "Lights",
                    items: lights.compactMap({ light -> DeviceCellModel in
                        DeviceCellModel(deviceType: .light, title: light.deviceName, onSelect: { [weak self] in
                            self?._selectedLight.accept(light)
                        }, onLongPress: { [weak self] in
                            self?._confirmDeviceRemoval.accept({ [weak self] in
                                light.delete()
                                self?.coreDataStack.saveContext()
                            })
                        })
                }))

                let heatersSection = DevicesSection(
                    header: "Heaters",
                    items: heaters.compactMap({ heater -> DeviceCellModel in
                        DeviceCellModel(deviceType: .heater, title: heater.deviceName, onSelect: { [weak self] in
                            self?._selectedHeater.accept(heater)
                        }, onLongPress: { [weak self] in
                            self?._confirmDeviceRemoval.accept({ [weak self] in
                                heater.delete()
                                self?.coreDataStack.saveContext()
                            })
                        })
                    }))

                let shuttersSection = DevicesSection(
                    header: "Shutters",
                    items: shutters.compactMap({ shutter -> DeviceCellModel in
                        DeviceCellModel(deviceType: .shutter, title: shutter.deviceName, onSelect: { [weak self] in
                            self?._selectedShutter.accept(shutter)
                        }, onLongPress: { [weak self] in
                            self?._confirmDeviceRemoval.accept({ [weak self] in
                                shutter.delete()
                                self?.coreDataStack.saveContext()
                            })
                        })
                    }))

                return [lightsSection, heatersSection, shuttersSection]
        }).bind(to: _devicesSections).disposed(by: disposeBag)
    }
}

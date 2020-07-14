//
//  DashboardViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/23/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class DashboardViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Properties
    private var devicesCollectionView: UICollectionView?
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DevicesSection>?

    // MARK: - ViewModel
    var viewModel: DashboardViewViewModel?

    // MARK: - Lifecycle

    override func loadView() {
        let rootView = UIView(frame: .zero)

        let flowLayout = UICollectionViewFlowLayout()
        let devicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        devicesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        rootView.addSubview(devicesCollectionView)
        rootView.backgroundColor = UIColor(hex: 0xfffff8)

        devicesCollectionView.backgroundColor = .clear
        devicesCollectionView.leftAnchor.constraint(equalTo: rootView.leftAnchor).isActive = true
        devicesCollectionView.rightAnchor.constraint(equalTo: rootView.rightAnchor).isActive = true
        devicesCollectionView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        devicesCollectionView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true

        self.devicesCollectionView = devicesCollectionView

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        }

        title = NSLocalizedString("Dashboard", comment: "")

        let button =
            UIBarButtonItem(
                image: UIImage(named: "user"),
                style: .plain,
                target: self,
                action: nil
        )

        button.rx.tap.subscribe({ [weak self] tapped in
            switch tapped {
            case .next(_):
                self?.pushUserScreen()
                break
            default:
                break
            }
        }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem  = button

        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.start()
    }

    // MARK: - Private methods

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: DashboardViewViewModel) {
        guard let devicesCollectionView = devicesCollectionView else {
            print("devicesCollectionView is not set up")
            return
        }

        let dataSource =
            RxCollectionViewSectionedReloadDataSource<DevicesSection>(
                configureCell: { (_, collectionView, indexPath, cellModel) -> UICollectionViewCell in
                    let cell: DeviceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setModel(cellModel)

                    return cell
            })

        dataSource.configureSupplementaryView = {
            (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let reusableHeader: DevicesCollectionViewHeader =
                    collectionView.dequeueReusableHeader(for: indexPath)

                let section = dataSource.sectionModels[indexPath.section]
                reusableHeader.setTitle(section.header)
                
                return reusableHeader
            default: fatalError("Unexpected element kind")
            }
        }

        viewModel.devicesSections.drive(
            devicesCollectionView.rx.items(dataSource: dataSource)
            ).disposed(by: disposeBag)

        devicesCollectionView.rx.modelSelected(DeviceCellModel.self).subscribe(onNext: { model in
            model.onSelect()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        viewModel.confirmDeviceRemoval.subscribe({ [weak self] event in
            switch event {
            case .next(let confirm):
                if let confirm = confirm {
                    let alertController = UIAlertController(title: "Remove the device",
                                                            message: "Are you sure you want to remove device?",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel",
                                                            style: .default,
                                                            handler: nil))

                    alertController.addAction(UIAlertAction(title: "Remove",
                                                            style: .default,
                                                            handler: { _ in
                                                                confirm()

                    }))

                    self?.present(alertController, animated: true, completion: nil)
                }
                break
            default:
                break
            }
        }).disposed(by: disposeBag)

        bindViewModelRoutes(viewModel)

        self.dataSource = dataSource
    }

    private func bindViewModelRoutes(_ viewModel: DashboardViewViewModel) {
        viewModel.selectedLight.subscribe({ [weak self] event in
            switch event {
            case .next(let light):
                if let _ = light {
                    self?.pushLightScreen()
                }
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.selectedShutter.subscribe({ [weak self] event in
            switch event {
            case .next(let shutter):
                if let _ = shutter {
                    self?.pushShutterScreen()
                }
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.selectedHeater.subscribe({ [weak self] event in
            switch event {
            case .next(let heater):
                if let _ = heater {
                    self?.pushHeaterScreen()
                }
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        guard let devicesCollectionView = devicesCollectionView else {
            print("devicesCollectionView is not set up")
            return
        }

        devicesCollectionView.registerReusableCell(type: DeviceCollectionViewCell.self)
        devicesCollectionView.registerReusableHeader(type: DevicesCollectionViewHeader.self)

        devicesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: nil)
        longPressGestureRecognizer.rx.event.subscribe({ event in
            switch event {
            case .next(let gestureRecognizer):
                guard gestureRecognizer.state != UIGestureRecognizer.State.ended else {
                    return
                }

                let p = gestureRecognizer.location(in: devicesCollectionView)
                if let indexPath = devicesCollectionView.indexPathForItem(at: p) {
                    do {
                        (try self.dataSource?.model(at: indexPath) as? DeviceCellModel)?.onLongPress()
                    } catch {
                        print("Failed to get model of long pressed cell")
                    }
                }
            default:
                break
            }
        }).disposed(by: disposeBag)

        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delaysTouchesBegan = true

        devicesCollectionView.addGestureRecognizer(longPressGestureRecognizer)
    }
}

// MARK: - Constants

extension DashboardViewController {
    fileprivate enum Defaults {

        static let itemTopMarginRatio: CGFloat = CGFloat(20.0/775.0)
        static let itemSideMarginRatio: CGFloat = CGFloat(25.0/375.0)
        static let itemSpacingRatio: CGFloat = CGFloat(15.0/375.0)

        static let itemWidthToHeightRatio = CGFloat(1.0)

        static let headerHeight = CGFloat(40.0)

        static let additionalMargin = CGFloat(15.0)
    }
}

// MARK: - HorizontalFloatingHeaderLayoutDelegate
extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: Defaults.headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth(), height: itemHeight())
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Defaults.itemTopMarginRatio * view.bounds.height,
                            left: sideMargin(),
                            bottom: 0.0,
                            right: sideMargin())
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.height * Defaults.itemTopMarginRatio
    }

    private func sideMargin() -> CGFloat {
        let margin = view.bounds.width * Defaults.itemSideMarginRatio
        return margin
    }

    private func itemWidth() -> CGFloat {
        let width = view.bounds.width - sideMargin() * 2.0
        return width / CGFloat(2.0) - (view.bounds.width * Defaults.itemSpacingRatio) / 2.0
    }

    private func itemHeight() -> CGFloat {
        return itemWidth() * (1.0 / Defaults.itemWidthToHeightRatio)
    }
}

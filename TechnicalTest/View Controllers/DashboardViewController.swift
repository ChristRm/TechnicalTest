//
//  DashboardViewController.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/23/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import UIKit
import RxDataSources

final class DashboardViewController: UIViewController {

    // MARK: - Properties
    var devicesCollectionView: UICollectionView?

    // MARK: - ViewModel
    var viewModel: DashboardViewViewModel?

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        let flowLayout = UICollectionViewFlowLayout()
        let devicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        devicesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(devicesCollectionView)

        devicesCollectionView.backgroundColor = .green
        devicesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        devicesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        devicesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        devicesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            print("collectionView is not set up")
            return
        }

//        let dataSource =
//            RxCollectionViewSectionedReloadDataSource<EmployeesSection>(
//                configureCell: { (_, collectionView, indexPath, cellModel) -> UICollectionViewCell in
//                    let cell: EmployeeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
//                    cell.setModel(cellModel)
//
//                    return cell
//            })
//
//        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
//            switch kind {
//            case UICollectionView.elementKindSectionHeader:
//                let reusableHeader =
//                    collectionView.dequeueReusableSupplementaryView(
//                        ofKind: UICollectionView.elementKindSectionHeader,
//                        withReuseIdentifier: "EmployeesCollectionViewHeader",
//                        for: indexPath
//                )
//
//                guard let descriptionLabel = reusableHeader.viewWithTag(1) as? UILabel else {
//                    fatalError("could not find the description label")
//                }
//
//                guard let rightSideImageView = reusableHeader.viewWithTag(2) as? UIImageView else {
//                    fatalError("could not find the image")
//                }
//
//                let section = dataSource.sectionModels[indexPath.section]
//                descriptionLabel.text = section.header
//                rightSideImageView.image = section.rightSideImage
//
//                return reusableHeader
//            default: fatalError("Unexpected element kind")
//            }
//        }
//
//        viewModel.employeesSections.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
//
//        viewModel.filtersViewViewModel.filtered.drive(onNext: { [weak self] filtered in
//            self?.filterBarButtonItem?.image = filtered ? UIImage(named: "icFiltered") : UIImage(named: "icFilter")
//            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    private func setupCollectionView() {
//        devicesCollectionView?.registerReusableCell(type: EmployeeCollectionViewCell.self)
//        devicesCollectionView?.register(
//            UINib(
//                nibName: "EmployeesCollectionViewHeader",
//                bundle: nil
//            ),
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: "EmployeesCollectionViewHeader"
//        )
//
//        devicesCollectionView?.rx.modelSelected(EmployeeCellModel.self).subscribe(
//            onNext: { [weak self] cell in
//                self?.performSegue(
//                    withIdentifier: String(describing: EmployeeProfileViewController.self),
//                    sender: cell
//                )
//            }, onError: nil,
//               onCompleted: nil,
//               onDisposed: nil
//            ).disposed(by: disposeBag)
//
//        devicesCollectionView?.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

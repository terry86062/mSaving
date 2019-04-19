//
//  CategoryAccountsDetailVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryAccountsDetailVC: UIViewController {

    @IBOutlet weak var categoryAccountsCollectionView: UICollectionView! {

        didSet {

            categoryAccountsCollectionView.dataSource = self

            categoryAccountsCollectionView.delegate = self

        }

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()

    }

    func setUpCollectionView() {

        categoryAccountsCollectionView.helpRegister(cell: CategoryAccountingsTotalCVCell())

        categoryAccountsCollectionView.helpRegister(cell: AccountingsCVCell())

    }

    @IBAction func pop(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)

    }

}

extension CategoryAccountsDetailVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 2

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {

            guard let cell = categoryAccountsCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategoryAccountingsTotalCVCell.self),
                for: indexPath) as? CategoryAccountingsTotalCVCell else {
                    return UICollectionViewCell()
            }

            return cell

        } else {

            guard let cell = categoryAccountsCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: AccountingsCVCell.self),
                for: indexPath) as? AccountingsCVCell else {
                    return UICollectionViewCell()
            }

            cell.initAccountsCVCell(haveHeader: true, accountings: [])

            return cell

        }

    }

}

extension CategoryAccountsDetailVC: UICollectionViewDelegate {

}

extension CategoryAccountsDetailVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {

            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

        } else {

            return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {

            return CGSize(width: 382, height: 56)

        } else {

            return CGSize(width: 382, height: 56 * 9)

        }

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

}

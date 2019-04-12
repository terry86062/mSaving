//
//  AccountsCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountsCVCell: UICollectionViewCell {

    @IBOutlet weak var accountsCollectionView: UICollectionView! {

        didSet {

            accountsCollectionView.dataSource = self

            accountsCollectionView.delegate = self

            setUpCollectionView()

        }

    }

    var goToAccountDetail: (() -> Void)?

    var haveHeader = false
    
    var accountings: [AccountingWithDate] = []

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountsCVCell(haveHeader: Bool, accountings: [AccountingWithDate]) {

        self.haveHeader = haveHeader
        
        self.accountings = accountings

    }

    func setUpCollectionView() {

        accountsCollectionView.helpRegisterView(cell: AccountDateCVCell())

        accountsCollectionView.helpRegister(cell: AccountCVCell())

    }

}

extension AccountsCVCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 9

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: AccountCVCell.self),
            for: indexPath) as? AccountCVCell else { return UICollectionViewCell() }

        cell.goToAccountDetail = goToAccountDetail

        return cell

    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: AccountDateCVCell.self),
            for: indexPath) as? AccountDateCVCell else {
                return AccountCVCell()
        }

        return headerView

    }

}

extension AccountsCVCell: UICollectionViewDelegate {

}

extension AccountsCVCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 382, height: 56)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        if haveHeader {

            return CGSize(width: 0, height: 56)

        } else {

            return CGSize(width: 0, height: 0)

        }

    }

}

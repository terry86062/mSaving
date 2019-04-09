//
//  SavingCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingCVCell: UICollectionViewCell {

    @IBOutlet weak var accountCollectionView: UICollectionView! {

        didSet {

            setUpCollectionView()

        }

    }

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initSavingCVCell(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {

        accountCollectionView.dataSource = dataSource

        accountCollectionView.delegate = delegate

    }

    func setUpCollectionView() {

        accountCollectionView.helpRegister(cell: SavingGoalCVCell())

        accountCollectionView.helpRegister(cell: AccountsCVCell())

        accountCollectionView.helpRegister(cell: SavingDetailCVCell())

        accountCollectionView.helpRegister(cell: AddSavingDetailCVCell())

    }

}

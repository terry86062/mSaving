//
//  IncomeExpenseCategoryCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class IncomeExpenseCategoryCVCell: UICollectionViewCell {

    @IBOutlet weak var incomeExpenseCategoryCollectionView: UICollectionView! {

        didSet {

            setUpCollectionView()

        }

    }

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func setUpCollectionView() {

        incomeExpenseCategoryCollectionView.helpRegister(cell: CategorysCVCell())

    }

    func initIncomeExpenseCategoryCVCell(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {

        incomeExpenseCategoryCollectionView.dataSource = dataSource

        incomeExpenseCategoryCollectionView.delegate = delegate

    }

}

//
//  SavingGoalCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/6.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingGoalCVCell: UICollectionViewCell {

    var goToSavingGoalDetail: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    @IBAction func goToSavingGoalDetail(_ sender: UIButton) {

        guard let goTo = goToSavingGoalDetail else { return }

        goTo()

    }

}

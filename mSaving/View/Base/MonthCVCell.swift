//
//  MonthCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MonthCVCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initMonthCVCell(month: String) {

        monthLabel.text = month

        shadowView.alpha = 0

    }

}

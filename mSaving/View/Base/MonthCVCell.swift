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
    
    var month: Month?

    override func awakeFromNib() {

        super.awakeFromNib()
        
        monthLabel.text = "\(TimeManager().todayMonth)月"

    }

    func initMonthCVCell(month: Month) {
        
        self.month = month

        monthLabel.text = "\(month.month)月"

    }

}

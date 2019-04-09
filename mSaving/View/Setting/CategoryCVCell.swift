//
//  CategoryCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {

    var goToSetCategory: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    @IBAction func goToSetCategory(_ sender: UIButton) {

        guard let goTo = goToSetCategory else { return }

        goTo()

    }

}

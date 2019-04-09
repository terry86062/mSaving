//
//  AccountCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class AccountCVCell: UICollectionViewCell {

    var goToAccountDetail: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func initAccountCVCell(zPosition: CGFloat) {

        self.layer.zPosition = zPosition

    }

    @IBAction func goToAccountDetail(_ sender: UIButton) {

        guard let goTo = goToAccountDetail else { return }

        goTo()

    }

}

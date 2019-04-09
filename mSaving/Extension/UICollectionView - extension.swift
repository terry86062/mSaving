//
//  UICollectionView - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

extension UICollectionView {

    func helpRegister<T>(cell: T) {

        let nibName = UINib(nibName: String(describing: T.self), bundle: nil)

        self.register(nibName, forCellWithReuseIdentifier: String(describing: T.self))

    }

    func helpRegisterView<T>(cell: T) {

        let nibName = UINib(nibName: String(describing: T.self), bundle: nil)

        self.register(nibName,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: String(describing: T.self))

    }

}

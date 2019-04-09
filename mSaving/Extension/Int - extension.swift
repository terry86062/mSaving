//
//  Int - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

extension Int {

    var fitScreen: CGFloat {

        return CGFloat(self) * UIScreen.main.bounds.width / 414

    }

}

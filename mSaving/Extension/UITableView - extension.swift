//
//  UITableView - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/3.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

extension UITableView {
    
    func helpRegister<T>(cell: T) {
        
        let nibName = UINib(nibName: String(describing: T.self), bundle: nil)
        
        self.register(nibName, forCellReuseIdentifier: String(describing: T.self))
        
    }
    
}

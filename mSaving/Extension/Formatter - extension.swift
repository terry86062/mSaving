//
//  Formatter - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let withSeparator: NumberFormatter = {
        
        let formatter = NumberFormatter()
        
        formatter.groupingSeparator = ","
        
        formatter.numberStyle = .decimal
        
        return formatter
        
    }()
    
}

//
//  String - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

extension String {
    
    func getRangeString(start: Int, end: Int) -> String {
        
        let start = self.index(self.startIndex, offsetBy: start)
        
        let end = self.index(self.startIndex, offsetBy: end)
        
        let range = start..<end
        
        return String(self[range])
        
    }
    
}

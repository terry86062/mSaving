//
//  URLComponents - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
    }
    
}

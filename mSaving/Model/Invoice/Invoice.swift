//
//  Invoice.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

struct InvoiceDetail: Codable {
    
    let msg: String
    
    let code: String
    
    let invNum: String
    
    let invoiceTime: String
    
    let invStatus: String
    
    let sellerName: String
    
    let invPeriod: String
    
    let sellerAddress: String
    
    let sellerBan: String
    
    let buyerBan: String
    
    let currency: String
    
    let details: [Goods]
    
    let invDate: String
    
    var totalAmount: Int {
        
        var total = 0
        
        guard details.count > 0 else { return 0 }
        
        for index in 0...details.count - 1 {
            
            guard let amount = Int(details[index].amount) else { return 0 }
            
            total += amount
            
        }
        
        return total
        
    }
    
}

struct Goods: Codable {
    
    let unitPrice: String
    
    let amount: String
    
    let quantity: String
    
    let rowNum: String
    
    let description: String
    
}

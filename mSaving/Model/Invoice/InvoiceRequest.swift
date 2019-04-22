//
//  InvoiceRequest.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

struct QRCodeInfo {
    
    let invNum: String
    
    let invDate: String
    
    let encrypt: String
    
    let sellerID: String
    
    let randomNumber: String
    
}

enum InvoiceRequest: MSRequest {
    
    case invoiceDetail(qrCodeInfo: QRCodeInfo, uuid: String)
    
    var endPoint: String {
        
        switch self {
            
        case .invoiceDetail: return "/PB2CAPIVAN/invapp/InvApp"
            
        }
        
    }
    
    var parameters: [String : String] {
        
        switch self {
            
        case .invoiceDetail(let qrCodeInfo, let uuid):
            
            return [
                "version": "0.5",
                "type": "QRCode",
                "invNum": qrCodeInfo.invNum,
                "action": "qryInvDetail",
                "generation": "V2",
                "invDate": qrCodeInfo.invDate,
                "encrypt": qrCodeInfo.encrypt,
                "sellerID": qrCodeInfo.sellerID,
                "UUID": uuid,
                "randomNumber": qrCodeInfo.randomNumber,
                "appID": "EINV6201904076324"
            ]
            
        }
        
    }
    
    var method: String {
        
        switch self {
            
        case .invoiceDetail: return MSHTTPMethod.POST.rawValue
            
        }
        
    }
    
    var headers: [String : String] {
        
        switch self {
            
        case .invoiceDetail: return [:]
            
        }
        
    }
    
    var body: Data? {
        
        switch self {
            
        case .invoiceDetail: return nil
            
        }
        
    }
    
}

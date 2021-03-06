//
//  InvoiceDownloader.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/22.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class InvoiceProvider {
    
    private let httpClient: HTTPClient
    
    init(client: HTTPClient = HTTPClient.shared) {
        
        httpClient = client
        
    }
    
    func downloadInvoiceDetail(qrCodeInfo: QRCodeInfo, uuid: String,
                               completionHandler: @escaping (Result<InvoiceDetail>) -> Void) {
        
        let request = InvoiceRequest.invoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid)
        
        httpClient.sendRequest(request) { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let invoiceDetail = try JSONDecoder().decode(InvoiceDetail.self, from: data)
                    
                    DispatchQueue.main.async {
                    
                        completionHandler(Result.success(invoiceDetail))
                        
                    }
                    
                } catch {
                    
                    completionHandler(Result.failure(error))
                    
                }
                
            case .failure(let error):
                
                completionHandler(Result.failure(error))
                
            }
            
        }
        
    }
    
}

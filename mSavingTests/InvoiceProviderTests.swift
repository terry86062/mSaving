//
//  InvoiceProviderTests.swift
//  mSavingTests
//
//  Created by 黃偉勛 Terry on 2019/5/14.
//  Copyright © 2019 Terry. All rights reserved.
//

import XCTest

@testable import mSaving

class MockHTTPClient: HTTPClient {
    
    var callSendRequest = false
    
    var testResult: Result<Data>?
    
    var uuid: String?
    
    var invNum: String?
    
    override func sendRequest(_ mSRequest: MSRequest, completionHandler: @escaping (Result<Data>) -> Void) {
        
        uuid = mSRequest.parameters["UUID"]
        
        invNum = mSRequest.parameters["invNum"]
        
        callSendRequest = true
        
        guard let test = testResult else { return }
        
        completionHandler(test)
        
    }
    
}

class InvoiceProviderTests: XCTestCase {
    
    var sut: InvoiceProvider!
    
    let mockHTTPClient = MockHTTPClient()

    override func setUp() {
        
        super.setUp()
        
        sut = InvoiceProvider(client: mockHTTPClient)
        
    }

    override func tearDown() {
        
        super.tearDown()
        
    }
    
    func test_downloadInvoiceDetail_callSendRequest() {
        
        // Arrange
        
        let qrCodeInfo = QRCodeInfo(invNum: "", invDate: "", encrypt: "", sellerID: "", randomNumber: "")
        
        let uuid = ""
        
        let completionHandler: (Result<InvoiceDetail>) -> Void = { _ in }
        
        // Action
        
        sut.downloadInvoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid, completionHandler: completionHandler)
        
        // Assert
        
        XCTAssertTrue(mockHTTPClient.callSendRequest)
        
    }
    
    func test_downloadInvoiceDetail_passParameter() {

        // Arrange
        
        let invNum = "test"

        let qrCodeInfo = QRCodeInfo(invNum: invNum, invDate: "", encrypt: "", sellerID: "", randomNumber: "")

        let uuid = "test"

        let completionHandler: (Result<InvoiceDetail>) -> Void = { _ in }

        // Action

        sut.downloadInvoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid, completionHandler: completionHandler)
        
        let actualInvNum = mockHTTPClient.invNum
        
        let actualUUID = mockHTTPClient.uuid

        // Assert
        
        XCTAssertEqual(actualInvNum, invNum)
        
        XCTAssertEqual(actualUUID, uuid)
        
    }
    
    func test_downloadInvoiceDetail_successParser() {
        
        // Arrange
        
        let qrCodeInfo = QRCodeInfo(invNum: "", invDate: "", encrypt: "", sellerID: "", randomNumber: "")
        
        let uuid = ""
        
        var actualInvoiceDetail: InvoiceDetail?
        
        let msg = "執行成功"
        
//        let expectation = self.expectation(description: "wait")
        
        let completionHandler: (Result<InvoiceDetail>) -> Void = { result in
            
            switch result {
                
            case .success(let data):
                
                actualInvoiceDetail = data
                
                // Assert

                XCTAssertEqual(msg, actualInvoiceDetail?.msg)
                
                XCTAssertNotNil(actualInvoiceDetail)
                
//                expectation.fulfill()
                
            case .failure:
                
                print("do nothing")
                
            }
            
        }
        
        mockHTTPClient.testResult = .success("""
        {
            "msg": \(msg),
            "code": "200",
            "invNum": "PD77311826",
            "invoiceTime": "21:07:25",
            "invStatus": "已確認",
            "sellerName": "微風場站開發股份有限公司",
            "invPeriod": "10804",
            "sellerAddress": "台北市北平西路3號2樓",
            "sellerBan": "28441577",
            "buyerBan": "",
            "currency": "",
            "details": [
                {
                    "unitPrice": "50",
                    "amount": "50",
                    "quantity": "1",
                    "rowNum": "1",
                    "description": "小南門點心世界"
                }
            ],
            "invDate": "20190420"
        }
        """.data(using: .utf8)!)
        
        // Action
        
        sut.downloadInvoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid, completionHandler: completionHandler)
        
//        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_downloadInvoiceDetail_failureParser() {
        
        // Arrange
        
        let qrCodeInfo = QRCodeInfo(invNum: "", invDate: "", encrypt: "", sellerID: "", randomNumber: "")
        
        let uuid = ""
        
        var actualError: Error?
        
        let completionHandler: (Result<InvoiceDetail>) -> Void = { result in
            
            switch result {
                
            case .success:
                
                print("do nothing")
                
            case .failure(let error):
                
                actualError = error
                
            }
            
        }
        
        mockHTTPClient.testResult = .success("""
        {
        }
        """.data(using: .utf8)!)
        
        // Action
        
        sut.downloadInvoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid, completionHandler: completionHandler)
        
        // Assert
        
        XCTAssertNotNil(actualError)
        
    }
    
    func test_downloadInvoiceDetail_failure() {
        
        // Arrange
        
        let qrCodeInfo = QRCodeInfo(invNum: "", invDate: "", encrypt: "", sellerID: "", randomNumber: "")
        
        let uuid = ""
        
        var actualError: Error?
        
        let completionHandler: (Result<InvoiceDetail>) -> Void = { result in
            
            switch result {
                
            case .success:
                
                print("do nothing")
                
            case .failure(let error):
                
                actualError = error
                
            }
            
        }
        
        mockHTTPClient.testResult = .failure(MSHTTPClientError.unexpectedError)
        
        // Action
        
        sut.downloadInvoiceDetail(qrCodeInfo: qrCodeInfo, uuid: uuid, completionHandler: completionHandler)
        
        // Assert
        
        XCTAssertNotNil(actualError)
        
    }

}

//
//  mSavingTests.swift
//  mSavingTests
//
//  Created by 黃偉勛 Terry on 2019/5/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import XCTest

// swiftlint:disable type_name
class mSavingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func add(aaa: Int, bbb: Int) -> Int {
        
        return 22
        
    }
    
    func testTerry() {
        
        // 3A - Arrange, Action, Assert
        
        // Arrange
        
        let aaa = 10
        
        let bbb = 20
        
        let expectedResult = aaa + bbb
        
        // Action
        
        let actualResult = add(aaa: aaa, bbb: bbb)
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
        
        print("test")
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

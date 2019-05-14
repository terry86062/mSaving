//
//  mSavingTests.swift
//  mSavingTests
//
//  Created by 黃偉勛 Terry on 2019/5/10.
//  Copyright © 2019 Terry. All rights reserved.
//

import XCTest

import CoreData

@testable import mSaving

private class MockNotificationManager: NotificationManager {
    
    var postAccountChangedWasCalled = false
    
    override func postAccountChanged(userInfo: [String: Account]?) {

        postAccountChangedWasCalled = true
    }
    
}

// swiftlint:disable type_name

class mSavingTests: XCTestCase {
    
    var sut: AccountProvider!
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "mSaving", managedObjectModel: managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        
        description.type = NSInMemoryStoreType
        
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (description, error) in
            
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                
                fatalError("Create an in-mem coordinator failed \(error)")
                
            }
            
        })
        
        return container
        
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        return managedObjectModel
        
    }()
    
    let account = AccountProvider()
    
    private let mockNotificationManager = MockNotificationManager()

    override func setUp() {
        
        super.setUp()
        
        sut = AccountProvider(coreDataManager: CoreDataManager(container: mockPersistentContainer),
                              notificationManager: mockNotificationManager)
        
        initStubs()
        
    }
    
    func initStubs() {
        
        _ = sut.createAccount(name: "1", initalAmount: 1)
        
        _ = sut.createAccount(name: "2", initalAmount: 2)
        
        _ = sut.createAccount(name: "3", initalAmount: 3)
        
    }

    override func tearDown() {
        
        flushData()
        
        super.tearDown()
        
    }
    
    func flushData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        guard let objs = try? mockPersistentContainer.viewContext.fetch(fetchRequest) as? [Account] else { return }
        
        for case let obj as NSManagedObject in objs {
            
            mockPersistentContainer.viewContext.delete(obj)
            
        }
        
        try? mockPersistentContainer.viewContext.save()
        
    }
    
    func test_accounts_fetchAll() {
        
        // Arrange
        
        let expectedResult = 3
        
        // Action
        
        let actualResult = sut.accounts.count
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
        
    }
    
    func test_createAccount_trueCreate() {
        
        // Arrange
        
        let name = "4"
        
        let initalAmount: Int64 = 4
        
        let expectedResult = sut.accounts.count + 1
        
        // Action
        
        sut.createAccount(name: name, initalAmount: initalAmount)
        
        let actualResult = sut.accounts.count
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
        
    }
    
    func test_createAccount_callPostNotification() {
        
        // Arrange
        
        let name = "4"
        
        let initalAmount: Int64 = 4
        
        // Action
        
        sut.createAccount(name: name, initalAmount: initalAmount)
        
        // Assert
        
        XCTAssertTrue(mockNotificationManager.postAccountChangedWasCalled)
        
    }
    
    func test_reviseAccount_reviseCorrect() {
        
        // Arrange
        
        let account = sut.accounts[0]
        
        let expectedName = "4"
        
        let expectedInitalValue: Int64 = 4
        
        let expectedCurrentValue = sut.accounts[0].currentValue - sut.accounts[0].initialValue + expectedInitalValue
        
        // Action
        
        sut.reviseAccount(account: account, name: expectedName, initialValue: expectedInitalValue)
        
        // Assert
        
        XCTAssertEqual(sut.accounts[0].name, expectedName)
        
        XCTAssertEqual(sut.accounts[0].initialValue, expectedInitalValue)
        
        XCTAssertEqual(sut.accounts[0].currentValue, expectedCurrentValue)
        
    }
    
    func test_reviseAccount_callPostNotification() {
        
        // Arrange
        
        let account = sut.accounts[0]
        
        let name = "4"
        
        let initalAmount: Int64 = 4
        
        // Action
        
        sut.reviseAccount(account: account, name: name, initialValue: initalAmount)
        
        // Assert
        
        XCTAssertTrue(mockNotificationManager.postAccountChangedWasCalled)
        
    }
    
    func test_deleteAccount_trueDelete() {
        
        // Arrange
        
        let account = sut.accounts[0]
        
        let expectedResult = sut.accounts.count - 1
        
        // Action
        
        sut.deleteAccount(account: account)
        
        let actualResult = sut.accounts.count
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
        
    }
    
    func test_deleteAccount_callPostNotification() {
        
        // Arrange
        
        let account = sut.accounts[0]
        
        // Action
        
        sut.deleteAccount(account: account)
        
        // Assert
        
        XCTAssertTrue(mockNotificationManager.postAccountChangedWasCalled)
        
    }

}

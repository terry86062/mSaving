//
//  AppDelegate.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/2.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import CoreData

import IQKeyboardManagerSwift

import Fabric

import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let uuid = UUID().uuidString

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        
        Fabric.with([Crashlytics.self])
        
        detectFirstLaunch()

        return true
        
    }
    
    func detectFirstLaunch() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore {
            
            print("Not first launch.")
            
        } else {
            
            print("First launch, setting NSUserDefault.")
            
            CategoryProvider().initExpenseIncomeCategory()
            
            AccountProvider().createAccount(name: "現金", initalAmount: 0, priority: 0)
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }
        
    }

}

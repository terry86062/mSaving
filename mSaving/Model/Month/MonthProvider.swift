//
//  MonthProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/25.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class MonthProvider {
    
    private let coreDataManager = CoreDataManager.shared
    
    private lazy var timeManager = TimeManager()
    
    var months: [Month] {
        
        return coreDataManager.fetch(entityType: Month(), sort: ["year", "month"])
        
    }
    
    func createCurrentMonth() -> Month {

        let month = Month(context: coreDataManager.viewContext)
        
        month.year = Int64(timeManager.todayYear)
        
        month.month = Int64(timeManager.todayMonth)
        
        return month

    }
    
}

//
//  MonthProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/25.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class MonthProvider {
    
    let coreDataManager = CoreDataManager.shared
    
    var months: [Month] {
        
        return coreDataManager.fetch(entityType: Month(), sort: ["year", "month"])
        
    }
    
    func createMonth(year: Int64, month: Int64) {
        
        let aMonth = Month(context: coreDataManager.viewContext)
        
        aMonth.year = year
        
        aMonth.month = month
        
        coreDataManager.saveContext()
        
    }
    
}

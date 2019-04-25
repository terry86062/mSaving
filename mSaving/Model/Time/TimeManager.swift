//
//  TimeManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/25.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class TimeManager {
    
    func transform(date: Date) -> DateComponents {
        
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
        
    }
    
    func createDate(year: Int?, month: Int?, day: Int?) -> Date? {
        
        var components = DateComponents()
        
        components.year = year
        
        components.month = month
        
        components.day = day
        
        return Calendar.current.date(from: components)
        
    }
    
}

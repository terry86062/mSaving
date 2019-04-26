//
//  TimeManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/25.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

class TimeManager {
    
    var todayYear: Int {
        
        guard let year = transform(date: Date()).year else { return 0 }
        
        return year
        
    }
    
    var todayMonth: Int {
        
        guard let month = transform(date: Date()).month else { return 0 }
        
        return month
        
    }
    
    func transform(int: Int64) -> DateComponents {
        
        let date = Date(timeIntervalSince1970: TimeInterval(int))
        
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
        
    }
    
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

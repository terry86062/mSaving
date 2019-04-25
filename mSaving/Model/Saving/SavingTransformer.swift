//
//  SavingTransformer.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/25.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

struct SavingWithDate {
    
    let saving: Saving
    
    let date: Date
    
    let dateComponents: DateComponents
    
}

class SavingTransformer {
    
    func transformFrom(savings: [Saving]) -> [SavingWithDate] {
        
        var savingsWithDate: [SavingWithDate] = []
        
        guard savings.count > 0 else { return [] }
        
        for index in 0...savings.count - 1 {
            
            let date = Date(timeIntervalSince1970: TimeInterval(savings[index].month))
            
            savingsWithDate.append(SavingWithDate(saving: savings[index], date: date, dateComponents:
                Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)))
            
        }
        
        return savingsWithDate
        
    }
    
    func transformFrom(savingsWithDate: [SavingWithDate]) -> [[SavingWithDate]] {
        
        var savingsWithDateGroup: [[SavingWithDate]] = []
        
        guard savingsWithDateGroup.count > 0 else { return [] }
        
        for index in 0...savingsWithDate.count - 1 {
            
            let savingWithDate = savingsWithDate[index]
            
            if index == 0 {
                
                savingsWithDateGroup.append([savingWithDate])
                
            } else {
                
                if savingWithDate.dateComponents.month == savingsWithDate[index - 1].dateComponents.month {
                    
                    savingsWithDateGroup[savingsWithDateGroup.count - 1].append(savingWithDate)
                    
                } else {
                    
                    savingsWithDateGroup.insert([savingWithDate], at: 0)
                    
                }
                
            }
            
        }
        
        return savingsWithDateGroup
        
    }
    
}

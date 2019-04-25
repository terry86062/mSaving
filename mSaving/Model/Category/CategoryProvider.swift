//
//  CategoryProvider.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/23.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

struct Category {
    
    let name: String
    
    let iconName: String
    
    let color: String
    
    let priority: Int64
    
    let subPriority: Int64
    
}

class CategoryProvider {
    
    var coreDataManager = CoreDataManager.shared
    
    var initCategoryArray = [
        Category(name: "食物", iconName: "cutleryForkKnife", color: "EE5142", priority: 1, subPriority: 1),
        Category(name: "飲料", iconName: "beverageMilkShake", color: "EE5142", priority: 1, subPriority: 2),
        Category(name: "交通", iconName: "car", color: "8A99AB", priority: 2, subPriority: 1),
        Category(name: "捷運", iconName: "trainSideView01", color: "8A99AB", priority: 2, subPriority: 2),
        Category(name: "家庭", iconName: "home", color: "69CAF9", priority: 3, subPriority: 1),
        Category(name: "水電", iconName: "waterTap", color: "69CAF9", priority: 3, subPriority: 2),
        Category(name: "電話", iconName: "contact", color: "69CAF9", priority: 3, subPriority: 3),
        Category(name: "寵物", iconName: "footprint", color: "69CAF9", priority: 3, subPriority: 4),
        Category(name: "娛樂", iconName: "eightNote", color: "F6B143", priority: 4, subPriority: 1),
        Category(name: "健身", iconName: "dumbbells", color: "F6B143", priority: 4, subPriority: 2),
        Category(name: "旅遊", iconName: "aeroplane", color: "F6B143", priority: 4, subPriority: 3),
        Category(name: "購物", iconName: "shoppingBag", color: "B751F8", priority: 5, subPriority: 1),
        Category(name: "衣服", iconName: "menTShirt", color: "B751F8", priority: 5, subPriority: 2),
        Category(name: "進修", iconName: "bookOpen", color: "7BDF3B", priority: 6, subPriority: 1),
        Category(name: "才藝", iconName: "color", color: "7BDF3B", priority: 6, subPriority: 2),
        Category(name: "醫療", iconName: "pill", color: "667BF7", priority: 7, subPriority: 1),
        Category(name: "人情", iconName: "gift", color: "55C4B3", priority: 7, subPriority: 1),
        Category(name: "投資", iconName: "stockExchange", color: "ED5190", priority: 8, subPriority: 1),
        Category(name: "保險", iconName: "addShield", color: "ED5190", priority: 9, subPriority: 2),
        Category(name: "薪水", iconName: "cash", color: "F9C746", priority: 1, subPriority: 1)
    ]
    
    var expenseCategories: [ExpenseCategory] {
        
        return coreDataManager.fetch(entityType: ExpenseCategory(), sort: ["priority", "subPriority"])
        
    }
    
    var incomeCategories: [IncomeCategory] {
        
        return coreDataManager.fetch(entityType: IncomeCategory(), sort: ["priority", "subPriority"])
        
    }
    
    func initExpenseIncomeCategory() {
        
        for index in 0...initCategoryArray.count - 1 {
            
            let category = initCategoryArray[index]
            
            if index == initCategoryArray.count - 1 {
                
                let incomeSubCategory = IncomeCategory(context: coreDataManager.viewContext)
                
                incomeSubCategory.name = category.name
                incomeSubCategory.iconName = category.iconName
                incomeSubCategory.color = category.color
                incomeSubCategory.priority = category.priority
                incomeSubCategory.subPriority = category.subPriority
                
            } else {
                
                let expenseSubCategory = ExpenseCategory(context: coreDataManager.viewContext)
                
                expenseSubCategory.name = category.name
                expenseSubCategory.iconName = category.iconName
                expenseSubCategory.color = category.color
                expenseSubCategory.priority = category.priority
                expenseSubCategory.subPriority = category.subPriority
                
            }
            
        }
        
        coreDataManager.saveContext()
        
    }
    
}

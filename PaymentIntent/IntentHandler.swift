//
//  IntentHandler.swift
//  PaymentIntent
//
//  Created by 黃偉勛 Terry on 2019/4/24.
//  Copyright © 2019 Terry. All rights reserved.
//

import Intents

class IntentHandler: INExtension { }

extension IntentHandler: INPayBillIntentHandling {

    func handle(intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {
        
        guard let amount = intent.transactionAmount?.amount?.amount?.doubleValue else {
            
            completion(INPayBillIntentResponse(code: .failure, userActivity: nil))
            
            return
            
        }

        let category = CategoryProvider().expenseCategories
        
        guard category != [] else {
            
            completion(INPayBillIntentResponse(code: .failure, userActivity: nil))
            
            return
            
        }

        let account = AccountProvider().accounts
        
        guard account != [] else {
            
            completion(INPayBillIntentResponse(code: .failure, userActivity: nil))
            
            return
            
        }
        
        guard let occurDate = createOccurDate(selectedDate: Date()) else { return }
        
        AccountingProvider().createAccounting(occurDate: occurDate,
                                              createDate: Date(),
                                              amount: Int64(amount),
                                              account: account[0],
                                              category: .expense(category[0]))

        completion(INPayBillIntentResponse(code: .success, userActivity: nil))

    }
    
    func createOccurDate(selectedDate: Date) -> Date? {
        
        let selectedComponents = TimeManager().transform(date: selectedDate)
        
        return TimeManager().createDate(year: selectedComponents.year,
                                        month: selectedComponents.month,
                                        day: selectedComponents.day)
        
    }

}

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

        guard let category = CategoryProvider().expenseCategory else {
            
            completion(INPayBillIntentResponse(code: .failure, userActivity: nil))
            
            return
            
        }

        AccountingProvider().saveAccounting(date: Date(),
                                            amount: Int64(amount),
                                            accountName: "現金",
                                            selectedExpenseCategory: category[0],
                                            selectedIncomeCategory: nil,
                                            selectedExpense: true)

        completion(INPayBillIntentResponse(code: .success, userActivity: nil))

    }

}

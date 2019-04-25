//
//  IntentViewController.swift
//  PaymentIntentUI
//
//  Created by 黃偉勛 Terry on 2019/4/24.
//  Copyright © 2019 Terry. All rights reserved.
//

import IntentsUI

class IntentViewController: UIViewController {
    
    @IBOutlet weak var addAccountingLabel: UILabel!
    
    var desiredSize: CGSize {
        
        return CGSize(width: 320, height: 150)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

}

extension IntentViewController: INUIHostedViewControlling {
    
    func configureView(for parameters: Set<INParameter>,
                       of interaction: INInteraction,
                       interactiveBehavior: INUIInteractiveBehavior,
                       context: INUIHostedViewContext,
                       completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        guard let inPayBillIntent = interaction.intent as? INPayBillIntent,
            let amount = inPayBillIntent.transactionAmount?.amount?.amount?.doubleValue else {
            
            addAccountingLabel.text = "金額讀取錯誤"
                
            return
            
        }
        
        addAccountingLabel.text = "記錄食物花費\(amount)元"
        
        completion(true, parameters, self.desiredSize)
        
    }
    
}

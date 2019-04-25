//
//  IntentViewController.swift
//  PaymentIntentUI
//
//  Created by 黃偉勛 Terry on 2019/4/24.
//  Copyright © 2019 Terry. All rights reserved.
//

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var addAccountingLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>,
                       of interaction: INInteraction,
                       interactiveBehavior: INUIInteractiveBehavior,
                       context: INUIHostedViewContext,
                       completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        completion(true, parameters, self.desiredSize)
        
    }
    
    var desiredSize: CGSize {
        
//        return self.extensionContext!.hostedViewMaximumAllowedSize
        
        return CGSize(width: 320, height: 150)
        
    }
    
}

extension IntentViewController {
    
    
    
}

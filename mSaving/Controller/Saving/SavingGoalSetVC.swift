//
//  SavingGoalSetVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingGoalSetVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        
    }
    
    @IBAction func pop(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

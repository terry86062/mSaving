//
//  SavingGoalSetVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingGoalSetVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var savingTextField: UITextField!
    
    var selectedYear = ""
    
    var selectedMonth = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        savingTextField.becomeFirstResponder()
        
        titleLabel.text = "\(selectedMonth)月預算"
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        saveSaving()
        
        helpDismiss()
        
    }
    
    func helpDismiss() {
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackView.isHidden = true
        
    }
    
    func saveSaving() {
        
        guard let amountText = savingTextField.text, let amount = Int64(amountText) else { return }
        
        var components = DateComponents()
        
        components.year = Int(selectedYear)
        components.month = Int(selectedMonth)
        components.day = 1
        
        guard let date = Calendar.current.date(from: components) else { return }
        
        StorageManager.shared.createSaving(main: true, date: date, amount: amount)
        
    }

}

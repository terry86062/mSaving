//
//  MainSavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MainSavingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var savingTextField: UITextField!
    
    var selectedMonth: Month?
    
    var selectedSaving: Saving?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        savingTextField.becomeFirstResponder()
        
        setUpView()
        
    }
    
    func setUpView() {
        
        if let selectedSaving = selectedSaving, let month = selectedSaving.month?.month {
            
            titleLabel.text = "\(month)月預算"
            
            savingTextField.text = "\(selectedSaving.amount)"
            
            descriptionLabel.text = "每天約可花 $" + "\(selectedSaving.amount / 30)"
            
        } else {
            
            if let selectedMonth = selectedMonth {
                
                titleLabel.text = "\(selectedMonth.month)月預算"
                
            } else {
                
                guard let month = TimeManager().transform(date: Date()).month else { return }
                
                titleLabel.text = "\(month)月預算"
                
            }
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if selectedSaving == nil {
            
            saveSaving()
            
        } else {
            
            reviseSaving()
            
        }
        
    }
    
    @IBAction func changeText(_ sender: UITextField) {
        
        guard let text = savingTextField.text, let budget = Int(text) else { return }
        
        descriptionLabel.text = "每天約可花 $" + String(budget / 30)
        
    }
    
    func helpDismiss() {
        
        savingTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
    }
    
    func saveSaving() {
        
        guard let amountText = savingTextField.text, let amount = Int64(amountText) else { return }
        
        if let selectedMonth = selectedMonth {
            
            SavingProvider().createSaving(month: selectedMonth, amount: amount)
            
        } else {
            
            let aMonth = Month(context: CoreDataManager.shared.viewContext)
            
            let dataComponents = TimeManager().transform(date: Date())
            
            guard let year = dataComponents.year, let month = dataComponents.month else { return }
            
            aMonth.year = Int64(year)
            
            aMonth.month = Int64(month)
            
            SavingProvider().createSaving(month: aMonth, amount: amount)
            
        }
        
        helpDismiss()
        
    }
    
    func reviseSaving() {
        
        guard let selectedSaving = selectedSaving else { return }
        
        guard let text = savingTextField.text, let amount = Int64(text) else { return }
        
        SavingProvider().reviseSaving(saving: selectedSaving, amount: amount)
        
        helpDismiss()
        
    }

}

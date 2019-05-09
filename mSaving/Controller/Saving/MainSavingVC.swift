//
//  MainSavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class MainSavingVC: PresentVC {

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
                
                titleLabel.text = "\(TimeManager().todayMonth)月預算"
                
            }
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        savingTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if selectedSaving == nil {
            
            saveSaving()
            
        } else {
            
            reviseSaving()
            
        }
        
    }
    
    func saveSaving() {
        
        guard let amountText = savingTextField.text, let amount = Int64(amountText) else { return }
        
        if let selectedMonth = selectedMonth {
            
            SavingProvider().createSaving(month: selectedMonth, amount: amount)
            
        } else {
            
            SavingProvider().createSaving(month: MonthProvider().createCurrentMonth(), amount: amount)
            
        }
        
        dismiss(UIButton())
        
    }
    
    func reviseSaving() {
        
        guard let selectedSaving = selectedSaving else { return }
        
        guard let text = savingTextField.text, let amount = Int64(text) else { return }
        
        SavingProvider().reviseSaving(saving: selectedSaving, amount: amount)
        
        dismiss(UIButton())
        
    }
    
    @IBAction func changeText(_ sender: UITextField) {
        
        guard let text = savingTextField.text, let budget = Int(text) else { return }
        
        descriptionLabel.text = "每天約可花 $" + String(budget / 30)
        
    }
    
}

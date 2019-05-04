//
//  SavingGoalSetVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/1.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import SwiftMessages

class SavingGoalSetVC: UIViewController {

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
            
            helpDismiss()
            
            showAddResult(selectedSaving: nil, month: selectedMonth, amount: amount)
            
        } else {
            
            let aMonth = Month(context: CoreDataManager.shared.viewContext)
            
            let dataComponents = TimeManager().transform(date: Date())
            
            guard let year = dataComponents.year, let month = dataComponents.month else { return }
            
            aMonth.year = Int64(year)
            
            aMonth.month = Int64(month)
            
            SavingProvider().createSaving(month: aMonth, amount: amount)
            
            helpDismiss()
            
            showAddResult(selectedSaving: nil, month: aMonth, amount: amount)
            
        }
        
    }
    
    func reviseSaving() {
        
        guard let selectedSaving = selectedSaving else { return }
        
        guard let text = savingTextField.text, let amount = Int64(text) else { return }
        
        SavingProvider().reviseSaving(saving: selectedSaving, amount: amount)
        
        helpDismiss()
        
        showAddResult(selectedSaving: selectedSaving, month: nil, amount: amount)
        
    }
    
    func showAddResult(selectedSaving: Saving?, month: Month?, amount: Int64) {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        if let saving = selectedSaving {
            
            guard let month = saving.month?.month else { return }
            
            view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
            
            view.configureContent(title: "修改成功", body: "已修改\(month)月預算", iconText: "\(month)月")
            
            view.button?.setTitle("$\(amount)", for: .normal)
            
        } else {
            
            guard let month = month?.month else { return }
            
            view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
            
            view.configureContent(title: "新增成功", body: "已新增\(month)月預算", iconText: "\(month)月")
            
            view.button?.setTitle("$\(amount)", for: .normal)
            
        }
        
        view.button?.backgroundColor = .clear
        
        view.button?.setTitleColor(.white, for: .normal)
        
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 12
        
        // Show the message.
        SwiftMessages.show(view: view)
        
    }

}

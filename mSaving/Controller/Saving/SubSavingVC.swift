//
//  SubSavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SubSavingVC: PresentVC {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subSavingTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var savingCategoryCollectionView: UICollectionView!
    
    let categoryCVVC = CategoryCollectionViewVC()
    
    var selectedMonth: Month?
    
    var selectedSubSaving: Saving?
    
    var selectedExpenseCategory: ExpenseCategory?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        setUpView()
        
    }
    
    func setUpCollectionView() {
        
        savingCategoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
        savingCategoryCollectionView.dataSource = categoryCVVC
        
        savingCategoryCollectionView.delegate = categoryCVVC
        
        categoryCVVC.delegate = self
        
    }
    
    func setUpView() {
        
        subSavingTextField.becomeFirstResponder()
        
        if selectedSubSaving == nil {
            
            titleLabel.text = "新增子預算"
            
            selectedCategoryImageView.backgroundColor = UIColor.mSYellow
            
            deleteButton.isHidden = true
            
        } else {
            
            guard let budget = selectedSubSaving?.amount else { return }
            
            subSavingTextField.text = String(budget)

            guard let expenseCategory = selectedSubSaving?.expenseCategory,
                let name = expenseCategory.name,
                let iconName = expenseCategory.iconName,
                let hex = expenseCategory.color else { return }
            
            selectedExpenseCategory = expenseCategory
            
            titleLabel.text = "\(name)預算"
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        subSavingTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if selectedSubSaving == nil {
            
            saveSaving()
            
        } else {
            
            reviseSaving()
            
        }
        
    }
    
    func saveSaving() {
        
        guard let amountText = subSavingTextField.text, let amount = Int64(amountText) else { return }
        
        guard let selectedExpenseCategory = selectedExpenseCategory else { return }
        
        if let selectedMonth = selectedMonth {
            
            SavingProvider().createSaving(month: selectedMonth, amount: amount, main: false,
                                          selectedExpenseCategory: selectedExpenseCategory)
            
        } else {
            
            let aMonth = Month(context: CoreDataManager.shared.viewContext)
            
            let dataComponents = TimeManager().transform(date: Date())
            
            guard let year = dataComponents.year, let month = dataComponents.month else { return }
            
            aMonth.year = Int64(year)
            
            aMonth.month = Int64(month)
            
            SavingProvider().createSaving(month: aMonth, amount: amount, main: false,
                                          selectedExpenseCategory: selectedExpenseCategory)
            
        }
        
        dismiss(UIButton())
        
    }
    
    func reviseSaving() {
        
        guard let selectedSavingDetail = selectedSubSaving else { return }
        
        guard let selectedExpenseCategory = selectedExpenseCategory else { return }
        
        guard let text = subSavingTextField.text, let amount = Int64(text) else { return }
        
        SavingProvider().reviseSaving(saving: selectedSavingDetail,
                                      amount: amount,
                                      selectedExpenseCategory: selectedExpenseCategory)
        
        dismiss(UIButton())
        
    }
    
    @IBAction func deleteSaving(_ sender: UIButton) {
        
        AlertManager().showDeleteAlertWith(saving: selectedSubSaving, viewController: self) { [weak self] in
            
            self?.dismiss(UIButton())
            
        }
        
    }
    
}

extension SubSavingVC: CategorySelectCVCellDelegate {
    
    func touchCategory(expense: ExpenseCategory?) {
        
        selectedExpenseCategory = expense
        
        guard let iconName = expense?.iconName, let color = expense?.color,
            let name = expense?.name else { return }

        titleLabel.text = "\(name)預算"

        selectedCategoryImageView.image = UIImage(named: iconName)

        selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
        
    }
    
}

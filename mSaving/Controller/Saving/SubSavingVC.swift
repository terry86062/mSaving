//
//  SubSavingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SubSavingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var savingDetailTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var savingCategoryCollectionView: UICollectionView! {
        
        didSet {
            
            savingCategoryCollectionView.dataSource = self
            
            savingCategoryCollectionView.delegate = self
            
        }
        
    }
    
    var expenseCategories: [ExpenseCategory] = []
    
    var selectedMonth: Month?
    
    var selectedSavingDetail: Saving?
    
    var selectedExpenseCategory: ExpenseCategory?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        setUpView()
        
    }
    
    func setUpCollectionView() {
        
        savingCategoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
    }
    
    func setUpView() {
        
        savingDetailTextField.becomeFirstResponder()
        
        expenseCategories = CategoryProvider().expenseCategories
        
        if selectedSavingDetail == nil {
            
            titleLabel.text = "新增子預算"
            
            selectedCategoryImageView.backgroundColor = UIColor.mSYellow
            
            deleteButton.isHidden = true
            
        } else {
            
            guard let budget = selectedSavingDetail?.amount else { return }
            
            savingDetailTextField.text = String(budget)

            guard let expenseCategory = selectedSavingDetail?.expenseCategory,
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
        
        savingDetailTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        hideTabBarVCBlackView()
        
    }
    
    func hideTabBarVCBlackView() {
        
        guard let tabBarVC = presentingViewController as? TabBarController else { return }
        
        tabBarVC.blackButton.isHidden = true
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if selectedSavingDetail == nil {
            
            saveSaving()
            
        } else {
            
            reviseSaving()
            
        }
        
    }
    
    @IBAction func deleteSaving(_ sender: UIButton) {
        
        guard let saving = selectedSavingDetail else { return }
        
        if let name = saving.expenseCategory?.name {
            
            showAlertWith(title: "您確定要刪除\(name)預算嗎？", message: nil)
            
        }
        
    }
    
    func showAlertWith(title: String, message: String?, style: UIAlertController.Style = .actionSheet) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .default, handler: { _ in
            
            guard let saving = self.selectedSavingDetail else { return }
            
            SavingProvider().delete(saving: saving)
            
            self.dismiss(UIButton())
            
        })
        
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func saveSaving() {
        
        guard let amountText = savingDetailTextField.text, let amount = Int64(amountText) else { return }
        
        guard let selectedExpenseCategory = selectedExpenseCategory else { return }
        
        if let selectedMonth = selectedMonth {
            
            SavingProvider().createSaving(month: selectedMonth,
                                          amount: amount,
                                          main: false,
                                          selectedExpenseCategory: selectedExpenseCategory)
            
        } else {
            
            let aMonth = Month(context: CoreDataManager.shared.viewContext)
            
            let dataComponents = TimeManager().transform(date: Date())
            
            guard let year = dataComponents.year, let month = dataComponents.month else { return }
            
            aMonth.year = Int64(year)
            
            aMonth.month = Int64(month)
            
            SavingProvider().createSaving(month: aMonth,
                                          amount: amount,
                                          main: false,
                                          selectedExpenseCategory: selectedExpenseCategory)
            
        }
        
        dismiss(UIButton())
        
    }
    
    func reviseSaving() {
        
        guard let selectedSavingDetail = selectedSavingDetail else { return }
        
        guard let selectedExpenseCategory = selectedExpenseCategory else { return }
        
        guard let text = savingDetailTextField.text, let amount = Int64(text) else { return }
        
        SavingProvider().reviseSaving(saving: selectedSavingDetail,
                                      amount: amount,
                                      selectedExpenseCategory: selectedExpenseCategory)
        
        dismiss(UIButton())
        
    }

}

extension SubSavingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseCategories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = savingCategoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        let expenseCategory = expenseCategories[indexPath.row]
        
        guard let iconName = expenseCategory.iconName,
            let name = expenseCategory.name,
            let color = expenseCategory.color else { return cell }
        
        cell.initCategorySelectCVCell(imageName: iconName, categoryName: name, hex: color)
        
        cell.selectCategory = {
            
            self.selectedExpenseCategory = expenseCategory
            
            self.titleLabel.text = "\(name)預算"
            
            self.selectedCategoryImageView.image = UIImage(named: iconName)
            
            self.selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            
        }
        
        return cell
        
    }
    
}

extension SubSavingVC: UICollectionViewDelegate { }

extension SubSavingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 43, bottom: 0, right: 38.2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 36, height: 84)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 38.2
        
    }
    
}

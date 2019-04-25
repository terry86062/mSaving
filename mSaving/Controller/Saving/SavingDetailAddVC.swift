//
//  SavingDetailAddVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/4.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SavingDetailAddVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var savingDetailTextField: UITextField!
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    @IBOutlet weak var savingCategoryCollectionView: UICollectionView! {
        
        didSet {
            
            savingCategoryCollectionView.dataSource = self
            
            savingCategoryCollectionView.delegate = self
            
        }
        
    }
    
    var selectedYear = ""
    
    var selectedMonth = ""
    
    var selectedSavingDetail: SavingWithDate?
    
    var selectedExpenseCategory: ExpenseCategory?
    
    var expenseCategorys: [ExpenseCategory] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCollectionView()
        
        savingDetailTextField.becomeFirstResponder()
        
        let expenseCategorys = CategoryProvider().expenseCategories
        
        self.expenseCategorys = expenseCategorys
        
        if selectedSavingDetail != nil {
            
            guard let name = selectedSavingDetail?.saving.expenseCategory?.name, let budget = selectedSavingDetail?.saving.amount else { return }
            
            titleLabel.text = "\(name)預算"
            
            savingDetailTextField.text = String(budget)
            
            guard let iconName = selectedSavingDetail?.saving.expenseCategory?.iconName, let hex = selectedSavingDetail?.saving.expenseCategory?.color else { return }
            
            selectedCategoryImageView.image = UIImage(named: iconName)
            
            selectedCategoryImageView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
            
        } else {
            
            titleLabel.text = "新增子預算"
            
            selectedCategoryImageView.backgroundColor = UIColor.mSGreen
            
        }
        
    }
    
    func setUpCollectionView() {
        
        savingCategoryCollectionView.helpRegister(cell: CategorySelectCVCell())
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        helpDismiss()
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if selectedSavingDetail != nil {
            
            reviseSubSaving()
            
        } else {
            
            saveSubSaving()
            
        }
        
        helpDismiss()
        
    }
    
    @IBAction func deleteSubSaving(_ sender: UIButton) {
        
        guard let subSaving = selectedSavingDetail?.saving else { return }
        
        SavingProvider().deleteSubSaving(subSaving: subSaving)
        
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
    
    func saveSubSaving() {
        
        guard let amountText = savingDetailTextField.text, let amount = Int64(amountText) else { return }
        
        var components = DateComponents()
        
        components.year = Int(selectedYear)
        components.month = Int(selectedMonth)
        components.day = 1
        
        guard let date = Calendar.current.date(from: components) else { return }
        
        guard let selectedExpenseCategory = selectedExpenseCategory else { return }
        
//        SavingProvider().createSaving(date: date, amount: amount, main: false,
//                                      selectedExpenseCategory: selectedExpenseCategory)
        
    }
    
    func reviseSubSaving() {
        
        guard let selectedSavingDetail = selectedSavingDetail else { return }
        
        guard let text = savingDetailTextField.text, let amount = Int64(text) else { return }
        
        selectedSavingDetail.saving.amount = amount
        
        selectedSavingDetail.saving.expenseCategory = selectedExpenseCategory
        
        CoreDataManager.shared.saveContext()
        
    }

}

extension SavingDetailAddVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseCategorys.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = savingCategoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorySelectCVCell.self),
            for: indexPath) as? CategorySelectCVCell else {
                return CategorySelectCVCell()
        }
        
        let expenseCategory = expenseCategorys[indexPath.row]
        
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

extension SavingDetailAddVC: UICollectionViewDelegate {
    
}

extension SavingDetailAddVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 57, height: 76)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}

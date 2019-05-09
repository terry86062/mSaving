//
//  CategoryVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import BetterSegmentedControl

class CategoryVC: UIViewController {

    @IBOutlet weak var categorySegmentedC: BetterSegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var expenseCollectionView: UICollectionView! {

        didSet {

            expenseCollectionView.dataSource = self

            expenseCollectionView.delegate = self

        }

    }
    
    @IBOutlet weak var incomeCollectionView: UICollectionView! {

        didSet {

            incomeCollectionView.dataSource = self

            incomeCollectionView.delegate = self

        }

    }
    
    var expenseCategories: [ExpenseCategory] = []
    
    var incomeCategories: [IncomeCategory] = []

    override func viewDidLoad() {

        super.viewDidLoad()
        
        scrollView.delegate = self

        setUpCollectionView()
        
        setUpSegmentedC()
        
        fetchData()

    }

    func setUpCollectionView() {
        
        expenseCollectionView.helpRegister(cell: CategorysCVCell())
        
        incomeCollectionView.helpRegister(cell: CategorysCVCell())

    }
    
    func setUpSegmentedC() {
        
        categorySegmentedC.segments = LabelSegment.segments(
            withTitles: ["支出", "收入"],
            normalBackgroundColor: UIColor.white,
            normalFont: .systemFont(ofSize: 16),
            normalTextColor: UIColor.lightGray,
            selectedBackgroundColor: UIColor.mSYellow,
            selectedFont: .systemFont(ofSize: 16),
            selectedTextColor: UIColor.black)
        
        categorySegmentedC.isEnabled = false
        
    }
    
    func fetchData() {
        
        expenseCategories = CategoryProvider().expenseCategories
        
        incomeCategories = CategoryProvider().incomeCategories
        
    }

    @IBAction func pop(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)

    }

}

extension CategoryVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 1

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CategorysCVCell.self),
            for: indexPath) as? CategorysCVCell else { return CategorysCVCell() }
        
        if collectionView == expenseCollectionView {

            cell.initCategorysCVCell(expense: expenseCategories, income: [])

        } else {

            cell.initCategorysCVCell(expense: [], income: incomeCategories)
            
        }
        
        cell.goToSetCategory = {
            
//            self.performSegue(withIdentifier: "goToSetCategoryVC", sender: nil)
            
        }
        
        return cell

    }

}

extension CategoryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == expenseCollectionView {
            
            return CGSize(width: Int(UIScreen.main.bounds.width - 32), height: 48 * expenseCategories.count + 12)
            
        } else {
            
            return CGSize(width: Int(UIScreen.main.bounds.width - 32), height: 48 * incomeCategories.count + 12)
            
        }
        
    }

}

extension CategoryVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(self.scrollView) {

            let move = self.scrollView.contentOffset.x

            if (move + 207) / 414 < 1 {

                categorySegmentedC.setIndex(0, animated: true)

            } else if (move + 207) / 414 >= 1 && (move + 207) / 414 < 2 {

                categorySegmentedC.setIndex(1, animated: true)

            }

        }

    }

}

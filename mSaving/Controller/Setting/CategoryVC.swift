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

    @IBOutlet weak var categoryCollectionView: UICollectionView! {

        didSet {

            categoryCollectionView.dataSource = self

            categoryCollectionView.delegate = self

        }

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()

        categorySegmentedC.segments = LabelSegment.segments(
            withTitles: ["支出", "收入"],
            normalBackgroundColor: UIColor.white,
            normalFont: .systemFont(ofSize: 16),
            normalTextColor: UIColor.mSYellow,
            selectedBackgroundColor: UIColor.mSYellow,
            selectedFont: .systemFont(ofSize: 16),
            selectedTextColor: UIColor.black)

    }

    func setUpCollectionView() {

        categoryCollectionView.helpRegister(cell: IncomeExpenseCategoryCVCell())

    }

    @IBAction func pop(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)

    }

}

extension CategoryVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == categoryCollectionView {

            return 2

        } else {

            return 1

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == categoryCollectionView {

            guard let cell = categoryCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: IncomeExpenseCategoryCVCell.self),
                for: indexPath) as? IncomeExpenseCategoryCVCell else {
                    return IncomeExpenseCategoryCVCell()
            }

            cell.initIncomeExpenseCategoryCVCell(dataSource: self, delegate: self)

            return cell

        } else {

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CategorysCVCell.self),
                for: indexPath) as? CategorysCVCell else { return CategorysCVCell() }

            cell.goToSetCategory = {

                self.performSegue(withIdentifier: "goToSetCategoryVC", sender: nil)

            }

            return cell

        }

    }

}

extension CategoryVC: UICollectionViewDelegate {

}

extension CategoryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == categoryCollectionView {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        } else {

            return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == categoryCollectionView {

            return CGSize(width: categoryCollectionView.frame.width, height: categoryCollectionView.frame.height)

        } else {

            return CGSize(width: 382, height: 56 * 9)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == categoryCollectionView {

            return 0

        } else {

            return 0

        }

    }

}

extension CategoryVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(categoryCollectionView) {

            let move = categoryCollectionView.bounds.origin.x

            print((move + 207) / 414)

            if (move + 207) / 414 < 1 {

                categorySegmentedC.setIndex(0, animated: true)

            } else if (move + 207) / 414 >= 1 && (move + 207) / 414 < 2 {

                categorySegmentedC.setIndex(1, animated: true)

            }

        }

    }

}

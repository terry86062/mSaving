//
//  SetCategoryVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class SetCategoryVC: UIViewController {

    @IBOutlet weak var colorCollectionView: UICollectionView! {

        didSet {

            colorCollectionView.dataSource = self

            colorCollectionView.delegate = self

        }

    }

    @IBOutlet weak var iconCollectionView: UICollectionView! {

        didSet {

            iconCollectionView.dataSource = self

            iconCollectionView.delegate = self

        }

    }

    @IBOutlet weak var iconTwoCollectionView: UICollectionView! {

        didSet {

            iconTwoCollectionView.dataSource = self

            iconTwoCollectionView.delegate = self

        }

    }

    @IBOutlet weak var iconThreeCollectionView: UICollectionView! {

        didSet {

            iconThreeCollectionView.dataSource = self

            iconThreeCollectionView.delegate = self

        }

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCollectionView()

    }

    func setUpCollectionView() {

        colorCollectionView.helpRegister(cell: IconCVCell())

    }

    @IBAction func pop(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)

    }

}

extension SetCategoryVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 18

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = colorCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: IconCVCell.self),
            for: indexPath) as? IconCVCell else { return IconCVCell() }

        return cell

    }

}

extension SetCategoryVC: UICollectionViewDelegate { }

extension SetCategoryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 56, height: 56)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }

}

extension SetCategoryVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isEqual(iconCollectionView) {

            iconTwoCollectionView.bounds.origin.x = iconCollectionView.bounds.origin.x

            iconThreeCollectionView.bounds.origin.x = iconCollectionView.bounds.origin.x

        } else if scrollView.isEqual(iconTwoCollectionView) {

            iconCollectionView.bounds.origin.x = iconTwoCollectionView.bounds.origin.x

            iconThreeCollectionView.bounds.origin.x = iconTwoCollectionView.bounds.origin.x

        } else if scrollView.isEqual(iconThreeCollectionView) {

            iconCollectionView.bounds.origin.x = iconThreeCollectionView.bounds.origin.x

            iconTwoCollectionView.bounds.origin.x = iconThreeCollectionView.bounds.origin.x

        }

    }

}

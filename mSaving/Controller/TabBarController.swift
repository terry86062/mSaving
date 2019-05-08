//
//  TabBarController.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

private enum Tab {

    case saving

    case chart

    case accounting

    case invoice

    case setting

    func makeController() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .saving: controller = UIStoryboard.saving.instantiateInitialViewController()!

        case .chart: controller = UIStoryboard.chart.instantiateInitialViewController()!

        case .accounting: controller = UIStoryboard.accounting.instantiateInitialViewController()!

        case .invoice: controller = UIStoryboard.invoice.instantiateInitialViewController()!

        case .setting: controller = UIStoryboard.setting.instantiateInitialViewController()!

        }

        controller.tabBarItem = makeTabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        return controller

    }

    func makeTabBarItem() -> UITabBarItem {

        switch self {

        case .saving:

            return UITabBarItem(
                title: nil,
                image: UIImage(named: "saving1"),
                selectedImage: UIImage(named: "saving1")
            )

        case .chart:

            return UITabBarItem(
                title: nil,
                image: UIImage(named: "chart"),
                selectedImage: UIImage(named: "chart")
            )

        case .accounting:

            return UITabBarItem(
                title: nil,
                image: UIImage(named: ""),
                selectedImage: UIImage(named: "")
            )

        case .invoice:

            return UITabBarItem(
                title: nil,
                image: UIImage(named: "QRcode"),
                selectedImage: UIImage(named: "QRcode")
            )

        case .setting:

            return UITabBarItem(
                title: nil,
                image: UIImage(named: "user1"),
                selectedImage: UIImage(named: "user1")
            )

        }

    }

}

class TabBarController: UITabBarController {

    private let tabs: [Tab] = [.saving, .chart, .accounting, .invoice, .setting]

    lazy var blackView: UIView = {
        
        let blackView = UIView()
        
        blackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        blackView.frame = UIScreen.main.bounds
        
        blackView.isHidden = true
        
        view.addSubview(blackView)
        
        return blackView
        
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        viewControllers = tabs.map({ $0.makeController() })

        viewControllers?[2].tabBarItem.isEnabled = false

        if var newButtonImage = UIImage(named: "plus")?.resizeImage(width: 120, height: 120) {

            newButtonImage = newButtonImage.imageWithColor(color1: .mSYellow)

            addCenterButton(withImage: newButtonImage, highlightImage: newButtonImage)
            
        }

    }

    func addCenterButton(withImage buttonImage: UIImage, highlightImage: UIImage) {

        let button = UIButton(type: .custom)
        
        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        
        button.frame = CGRect(x: 0.0, y: 0.0,
                              width: buttonImage.size.width / 2.0,
                              height: buttonImage.size.height / 2.0)

        button.setImage(buttonImage, for: .normal)

        let rectBoundTabbar = self.tabBar.bounds
        
        if UIScreen.main.bounds.height < 800 {
            
            let paddingBottom: CGFloat = 12.5
            
            let xxx = rectBoundTabbar.midX
            
            let yyy = rectBoundTabbar.midY - paddingBottom
            
            button.center = CGPoint(x: xxx, y: yyy)
            
        } else if UIScreen.main.bounds.height > 800 {
            
            let paddingBottom: CGFloat = -14
            
            let xxx = rectBoundTabbar.midX
            
            let yyy = rectBoundTabbar.midY - paddingBottom
            
            button.center = CGPoint(x: xxx, y: yyy)
            
        }
    
        button.backgroundColor = UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1)

        button.layer.cornerRadius = 30

        button.layer.borderWidth = 5

        button.layer.borderColor = UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1).cgColor

        addTwoColorView(buttonImage: buttonImage)

        self.tabBar.addSubview(button)
        
        self.tabBar.bringSubviewToFront(button)

        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
        
    }
    
    func addTwoColorView(buttonImage: UIImage) {
        
        let twoColorView = UIView(frame: CGRect(x: 0, y: 0,
                                                width: (buttonImage.size.width / 2.0) + 1,
                                                height: (buttonImage.size.height / 2.0) + 1))
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = twoColorView.bounds
        
        gradientLayer.colors = [
            UIColor(red: 175 / 255, green: 175 / 255, blue: 175 / 255, alpha: 1).cgColor,
            UIColor(red: 175 / 255, green: 175 / 255, blue: 175 / 255, alpha: 1).cgColor,
            UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1).cgColor,
            UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1).cgColor
        ]
        
        gradientLayer.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: 0.3),
            NSNumber(value: 0.3),
            NSNumber(value: 1.0)
        ]
        
        gradientLayer.cornerRadius = ((buttonImage.size.width / 2.0) + 1) / 2
        
        twoColorView.layer.addSublayer(gradientLayer)
        
        let paddingBottom2: CGFloat = 12.5
        
        let rectBoundTabbar2 = self.tabBar.bounds
        
        let xx2 = rectBoundTabbar2.midX
        
        let yy2 = rectBoundTabbar2.midY - paddingBottom2
        
        twoColorView.center = CGPoint(x: xx2, y: yy2)
        
        self.tabBar.addSubview(twoColorView)
        
    }

    @objc func handleTouchTabbarCenter(sender: UIButton) {

        if let accountingVC = UIStoryboard.accounting.instantiateInitialViewController() {

            accountingVC.modalPresentationStyle = .overCurrentContext
            
            blackView.isHidden = false

            present(accountingVC, animated: true, completion: nil)
            
        }

    }

}

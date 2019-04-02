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
                image: UIImage(named: "saving1")?.resizeImage(),
                selectedImage: UIImage(named: "saving1")?.resizeImage()
            )
            
        case .chart:
            
            return UITabBarItem(
                title: nil,
                image: UIImage(named: "chart")?.resizeImage(),
                selectedImage: UIImage(named: "chart")?.resizeImage()
            )
            
        case .accounting:
            
            return UITabBarItem(
                title: nil,
                image: UIImage(named: "plus")?.resizeImage(),
                selectedImage: UIImage(named: "plus")?.resizeImage()
            )
            
        case .invoice:
            
            return UITabBarItem(
                title: nil,
                image: UIImage(named: "QRcode")?.resizeImage(),
                selectedImage: UIImage(named: "QRcode")?.resizeImage()
            )
            
        case .setting:
            
            return UITabBarItem(
                title: nil,
                image: UIImage(named: "user1")?.resizeImage(),
                selectedImage: UIImage(named: "user1")?.resizeImage()
            )
            
        }
        
    }
    
}

class TabBarController: UITabBarController {
    
    private let tabs: [Tab] = [.saving, .chart, .accounting, .invoice, .setting]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.makeController() })
        
        delegate = self
        
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
}

//
//  MessageViewManager.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/5/7.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

import SwiftMessages

class MessageViewManager {
    
    enum MessageType: String {
        
        case add = "新增"
        
        case revise = "修改"
        
        case delete = "刪除"
        
    }
    
    private enum MessageStyle {
        
        case label(body: String, iconText: String, amount: String, backgroundColor: UIColor)
        
        case image(body: String, iconImage: UIImage, amount: String, backgroundColor: UIColor)
        
    }
    
    private func showMessageView(type: MessageType, style: MessageStyle) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.warning)
        
        view.configureDropShadow()
        
        switch style {
            
        case .label(let body, let iconText, let amount, let backgroundColor):
            
            view.configureTheme(backgroundColor: backgroundColor, foregroundColor: .white)
            
            view.configureContent(title: "\(type.rawValue)成功", body: body, iconText: iconText)
            
            view.button?.setTitle(amount, for: .normal)
            
        case .image(let body, let iconImage, let amount, let backgroundColor):
            
            view.configureTheme(backgroundColor: backgroundColor, foregroundColor: .white)
            
            view.configureContent(title: "\(type.rawValue)成功", body: body, iconImage: iconImage)
            
            view.button?.setTitle(amount, for: .normal)
            
        }
        
        view.button?.backgroundColor = .clear
        
        view.button?.setTitleColor(.white, for: .normal)
        
        view.layoutMarginAdditions = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 12
        
        SwiftMessages.show(view: view)
        
    }
    
    func show(saving: Saving, type: MessageType) {
        
        guard let month = saving.month?.month else { return }
        
        showMessageView(type: type, style: .label(body: "已\(type.rawValue)\(month)月預算",
                                                  iconText: "\(month)月",
                                                  amount: "$\(saving.amount)",
                                                  backgroundColor: .mSGreen))
        
    }
    
    func show(subSaving: Saving, type: MessageType) {
        
        guard let month = subSaving.month?.month, let expense = subSaving.expenseCategory, let name = expense.name,
            let color = expense.color, let iconName = expense.iconName,
            let iconImage = UIImage(named: iconName) else { return }
        
        showMessageView(type: type, style: .image(body: "已\(type.rawValue)\(month)月\(name)預算",
                                                  iconImage: iconImage.resizeImage(),
                                                  amount: "$\(subSaving.amount)",
                                                  backgroundColor: UIColor.hexStringToUIColor(hex: color)))
        
    }
    
    func show(accounting: Accounting, type: MessageType) {
        
        if let expense = accounting.expenseCategory {
            
            guard let name = expense.name, let color = expense.color, let iconName = expense.iconName,
                let iconImage = UIImage(named: iconName) else { return }
            
            showMessageView(type: type, style: .image(body: "已\(type.rawValue)一筆\(name)交易",
                                                      iconImage: iconImage.resizeImage(),
                                                      amount: "-$\(accounting.amount)",
                                                      backgroundColor: UIColor.hexStringToUIColor(hex: color)))
            
        } else if let income = accounting.incomeCategory {
            
            guard let name = income.name, let color = income.color, let iconName = income.iconName,
                let iconImage = UIImage(named: iconName) else { return }
            
            showMessageView(type: type, style: .image(body: "已\(type.rawValue)一筆\(name)交易",
                                                      iconImage: iconImage.resizeImage(),
                                                      amount: "$\(accounting.amount)",
                                                      backgroundColor: UIColor.hexStringToUIColor(hex: color)))
            
        }
        
    }
    
//    func showAddResult(selected: Bool, name: String, amount: Int64, delete: Bool = false) {
//        
//        if delete {
//            
//            view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
//            
//            view.configureContent(title: "刪除成功", body: "已刪除\(name)帳戶", iconText: "\(name)")
//            
//            view.button?.setTitle("$\(amount)", for: .normal)
//            
//        } else {
//            
//            if selected {
//                
//                view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
//                
//                view.configureContent(title: "修改成功", body: "已修改\(name)帳戶初始金額", iconText: "\(name)")
//                
//                view.button?.setTitle("$\(amount)", for: .normal)
//                
//            } else {
//                
//                view.configureTheme(backgroundColor: .mSGreen, foregroundColor: .white)
//                
//                view.configureContent(title: "新增成功", body: "已新增\(name)帳戶", iconText: "\(name)")
//                
//                view.button?.setTitle("$\(amount)", for: .normal)
//                
//            }
//            
//        }
//        
//    }
    
}

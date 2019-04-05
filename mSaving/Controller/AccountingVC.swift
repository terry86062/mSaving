//
//  AccountingVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import FSCalendar

import BetterSegmentedControl

class AccountingVC: UIViewController, UIGestureRecognizerDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: TopView!
    
    var gradientLayer: CAGradientLayer!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    @IBOutlet weak var incomeExpenseSegmentedC: BetterSegmentedControl!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
//        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        createGradientLayer()
        
        incomeExpenseSegmentedC.segments = LabelSegment.segments(withTitles: ["支出", "收入", "移轉"], normalBackgroundColor: UIColor.white, normalFont: .systemFont(ofSize: 16), normalTextColor: UIColor.mSYellow, selectedBackgroundColor: UIColor.mSYellow, selectedFont: .systemFont(ofSize: 16), selectedTextColor: UIColor.black)
        
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.topView.bounds
        
        gradientLayer.colors = [UIColor(red: 101 / 255, green: 177 / 255, blue: 80 / 255, alpha: 1).cgColor, UIColor(red: 57 / 255, green: 130 / 255, blue: 69 / 255, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientLayer.shadowOffset = CGSize(width: 0, height: 2)
        
        gradientLayer.shadowOpacity = 0.8
        
        gradientLayer.shadowRadius = 2
        
        gradientLayer.shadowColor = UIColor.gray.cgColor
        
        gradientLayer.zPosition = -1
        
        self.view.layer.addSublayer(gradientLayer)
        
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
//        if shouldBegin {
//            let velocity = self.scopeGesture.velocity(in: self.view)
//            switch self.calendar.scope {
//            case .month:
//                return velocity.y < 0
//            case .week:
//                return velocity.y > 0
//            }
//        }
//        return shouldBegin
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: bounds.height + view.safeAreaInsets.top + 68)
        
//        self.topViewHeightConstraint.constant = 100 //bounds.height + view.safeAreaInsets.top
        
        print("boundingRectWillChange")
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

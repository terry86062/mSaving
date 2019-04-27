//
//  BarChartCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Charts

class BarChartCVCell: UICollectionViewCell {

    @IBOutlet weak var barChart: BarChartView!

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func barChartUpdate(accountingWithDateArray: [[Accounting]]) {
        
        var entries: [ChartDataEntry] = []
        
        guard accountingWithDateArray.count > 0 else { return }
        
//        for index in 0...accountingWithDateArray.count - 1 {
//
//            guard let day = accountingWithDateArray[index].first?.dateComponents.day else { return }
//
//            var totalSpendPerDay: Int64 = 0
//
//            for indexx in 0...accountingWithDateArray[index].count - 1 {
//
//                totalSpendPerDay += accountingWithDateArray[index][indexx].accounting.amount
//
//            }
//
//            entries.append(BarChartDataEntry(x: Double(day), y: Double(totalSpendPerDay)))
//
//        }
        
        /*
         
         for index in 0...accountingWithDateArray.count - 1 {
         
         guard let day = accountingWithDateArray[index].first?.dateComponents.day else { return }
         
         if index == 0 {
         
         var firstDay = 1
         
         while day > firstDay {
         
         entries.append(BarChartDataEntry(x: Double(firstDay), y: 0))
         
         firstDay += 1
         
         }
         
         } else {
         
         guard var previousDay = accountingWithDateArray[index - 1].first?.dateComponents.day else { return }
         
         while previousDay + 1 < day {
         
         entries.append(BarChartDataEntry(x: Double(previousDay + 1), y: 0))
         
         previousDay += 1
         
         }
         
         }
         
         var totalSpendPerDay: Int64 = 0
         
         for indexx in 0...accountingWithDateArray[index].count - 1 {
         
         totalSpendPerDay += accountingWithDateArray[index][indexx].accounting.amount
         
         }
         
         entries.append(BarChartDataEntry(x: Double(day), y: Double(totalSpendPerDay)))
         
         }
         
         guard var lastDay = accountingWithDateArray[accountingWithDateArray.count - 1].first?.dateComponents.day,
         let date = accountingWithDateArray.first?.first?.date else { return }
         
         let totalDay = countOfDaysInCurrentMonth(date: date)
         
         while lastDay + 1 <= totalDay {
         
         entries.append(BarChartDataEntry(x: Double(lastDay + 1), y: 0))
         
         lastDay += 1
         
         }
         
        */
        
//        guard let date = accountingWithDateArray.first?.first?.date else { return }
        
//        let totalDay = countOfDaysInCurrentMonth(date: date)
        
        let dataSet = BarChartDataSet(values: entries, label: "每日花費")
        
        let data = BarChartData(dataSets: [dataSet])
        
        barChart.data = data
        
//        barChart.chartDescription?.text = "Number of Widgets by Type"

        //All other additions to this function will go here
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
//        barChart.legend.enabled = false
        
        barChart.xAxis.labelPosition = .bottom
        
//        xAxis.granularity = totalDay
//        barChart.xAxis.labelCount = totalDay / 2
        
        //This must stay at end of function
        barChart.notifyDataSetChanged()

    }
    
    func countOfDaysInCurrentMonth(date: Date) ->Int {
        
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        
        return (range?.length)!
        
    }

}

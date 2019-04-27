//
//  PieChartCVCell.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/5.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import Charts

class PieChartCVCell: UICollectionViewCell {

    @IBOutlet weak var pieChart: PieChartView!

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    func pieChartUpdate(monthTotal: [CategoryMonthTotal], isIncome: Bool) {
        
        pieChart.data = PieChartData(dataSet: PieChartDataSet(values: [], label: ""))
        
        pieChart.notifyDataSetChanged()

        guard monthTotal.count != 0 else { return }
        
        var dataArray: [ChartDataEntry] = []
        
        for index in 0...monthTotal.count - 1 {
            
            if isIncome {
                
                if let incomeCategory = monthTotal[index].accountings[0][0].incomeCategory {
                    
                    dataArray.append(PieChartDataEntry(value: Double(monthTotal[index].amount),
                                                       label: incomeCategory.name))
                    
                }
                
            } else {
                
                if let expenseCategory = monthTotal[index].accountings[0][0].expenseCategory {
                    
                    dataArray.append(PieChartDataEntry(value: Double(monthTotal[index].amount),
                                                       label: expenseCategory.name))
                    
                }
                
            }
            
        }
        
        let dataSet = PieChartDataSet(values: dataArray, label: "")
        
        var colors: [NSUIColor] = []
        
        for index in 0...monthTotal.count - 1 {

            if isIncome {
                
                if let color = monthTotal[index].accountings[0][0].incomeCategory?.color {
                    
                    colors.append(UIColor.hexStringToUIColor(hex: color))
                    
                }
                
            } else {
                
                if let color = monthTotal[index].accountings[0][0].expenseCategory?.color {
                    
                    colors.append(UIColor.hexStringToUIColor(hex: color))
                    
                }
                
            }
            
        }
        
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.legend.enabled = false
        
        pieChart.data = data
//        pieChart.chartDescription?.text = "Share of Widgets by Type"

        //All other additions to this function will go here

//        dataSet.colors = ChartColorTemplates.joyful()

        //This must stay at end of function
        pieChart.notifyDataSetChanged()

    }

}

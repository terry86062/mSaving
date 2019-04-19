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

    func pieChartUpdate(categoryAccountingMonthTotals: [CategoryAccountingMonthTotal]) {

        guard categoryAccountingMonthTotals.count != 0 else { return }
        
        var dataArray: [ChartDataEntry] = []
        
        for index in 0...categoryAccountingMonthTotals.count - 1 {
            
            dataArray.append(PieChartDataEntry(value: Double(categoryAccountingMonthTotals[index].amount), label: categoryAccountingMonthTotals[index].expenseCategory.name))
            
        }
        
        let dataSet = PieChartDataSet(values: dataArray, label: "")
        
        var colors: [NSUIColor] = []
        
        for index in 0...categoryAccountingMonthTotals.count - 1 {

            guard let color = categoryAccountingMonthTotals[index].expenseCategory.color else { return }

            colors.append(UIColor.hexStringToUIColor(hex: color))

        }
        
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
//        pieChart.chartDescription?.text = "Share of Widgets by Type"

        //All other additions to this function will go here

//        dataSet.colors = ChartColorTemplates.joyful()

        //This must stay at end of function
        pieChart.notifyDataSetChanged()

    }

}

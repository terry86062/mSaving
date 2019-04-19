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
        
        let entry1 = PieChartDataEntry(value: 10, label: "#1")
        let entry2 = PieChartDataEntry(value: 5, label: "#2")
        let entry3 = PieChartDataEntry(value: 20, label: "#3")
        let entry4 = PieChartDataEntry(value: 30, label: "#4")
        let entry5 = PieChartDataEntry(value: 15, label: "#5")
        let entry6 = PieChartDataEntry(value: 25, label: "#6")
        let entry7 = PieChartDataEntry(value: 40, label: "#7")
        let entry8 = PieChartDataEntry(value: 2, label: "#8")
        
//        let dataSet = PieChartDataSet(values: [
//            entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8
//            ], label: "Widget Types")
        
        let dataSet = PieChartDataSet(values: dataArray, label: "")
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
//        pieChart.chartDescription?.text = "Share of Widgets by Type"

        //All other additions to this function will go here

        dataSet.colors = ChartColorTemplates.joyful()

        //This must stay at end of function
        pieChart.notifyDataSetChanged()

    }

}

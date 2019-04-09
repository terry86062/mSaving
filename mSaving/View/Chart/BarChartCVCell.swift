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

    func barChartUpdate() {

        let entry1 = BarChartDataEntry(x: 1.0, y: 10)
        let entry2 = BarChartDataEntry(x: 2.0, y: 20)
        let entry3 = BarChartDataEntry(x: 3.0, y: 30)
        let entry4 = BarChartDataEntry(x: 4.0, y: 40)
        let entry5 = BarChartDataEntry(x: 5.0, y: 50)
        let entry6 = BarChartDataEntry(x: 6.0, y: 60)
        let entry7 = BarChartDataEntry(x: 7.0, y: 70)
        let entry8 = BarChartDataEntry(x: 8.0, y: 80)
        let entry9 = BarChartDataEntry(x: 9.0, y: 90)
        let dataSet = BarChartDataSet(values: [
            entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9
            ], label: "Widgets Type")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.chartDescription?.text = "Number of Widgets by Type"

        //All other additions to this function will go here

        //This must stay at end of function
        barChart.notifyDataSetChanged()

    }

}

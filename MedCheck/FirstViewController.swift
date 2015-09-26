//
//  FirstViewController.swift
//  MedCheck
//
//  Created by Iain Nash on 9/26/15.
//  Copyright © 2015 Iain Nash. All rights reserved.
//

import UIKit
import Charts
import Foundation

class FirstViewController: UIViewController, ChartViewDelegate {

  @IBOutlet var chartView: LineChartView!
  
  override func viewDidLoad() {
    chartView.descriptionText = "data from heart monitor sensor"
    chartView.noDataText = "no data yet"
    chartView.pinchZoomEnabled = false
    chartView.dragEnabled = true
    chartView.drawGridBackgroundEnabled = false
    
    chartView.legend.enabled = false
    chartView.leftAxis.enabled = false
    chartView.rightAxis.enabled = false
    chartView.xAxis.enabled = false
    
    
    chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    setData()
    
    super.viewDidLoad()
  }

  func setData() {
    let yvals: NSMutableArray = NSMutableArray()
    for index in 1...100 {
      yvals.addObject(BarChartDataEntry(value: 2 * sin(Double(index)), xIndex: index))
    }
    let xvals: NSMutableArray = NSMutableArray()
    for index in 1...100 {
      xvals.addObject(String(index))
    }
    
    let set1 : LineChartDataSet = LineChartDataSet(yVals: (yvals as NSArray as! [ChartDataEntry]), label: "Dataset 1")
    set1.drawCubicEnabled = true
    set1.cubicIntensity = 0.2
    set1.drawCirclesEnabled = false
    set1.lineWidth = 2.0
    set1.highlightColor = UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0)
    let data : LineChartData = LineChartData(xVals: xvals as NSArray as! [String], dataSet: set1)
    chartView.data = data;
    chartView.setNeedsDisplay()
    chartView.notifyDataSetChanged()
    chartView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}


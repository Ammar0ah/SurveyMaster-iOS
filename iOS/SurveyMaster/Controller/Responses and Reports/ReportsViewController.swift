//
//  ReportsViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/3/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts
class ReportsViewController: UIViewController {
    var Sid : String = ""
    var reports : [Report] = []
    var i = 0
    var chartView: BarChartView!
    var pieChartView : PieChartView!
    var lineChart : LineChartView!
    var bubbleChart : BubbleChartView!
    var tempView : UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet var previousBtn: UIButton!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var questionTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest(url: ShowSurveysURL+"/\(Sid)/report")
        chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
          pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            lineChart = LineChartView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        bubbleChart = BubbleChartView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        // Do any additional setup after loading the view.
    }
    
    
    func getRequest(url: String){
        
        let group = DispatchGroup()
        group.enter()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders)
            .responseJSON { (response) in
                if response.result.isSuccess{
                    if let response = response.result.value {
                        
                        let json = JSON(response)
                        self.updateAnswers(json: json)
                        print(json)
                        group.leave()
                    }
                }
        }
        
    }
    
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
        nextBtn.titleLabel?.text! = "Next"
     
        if !reports.isEmpty  {
            
            
            i += 1
            
            
            if i == reports.count  {
                i = 0
            }
            
            questionTitleLabel.text! = reports[i].title
            setupChart(type: reports[i].type, i: i)
               print(reports[i].type)
        }
    }
    
    
    func updateAnswers(json : JSON){
        let answers = json["answers"]
        for answer in answers.arrayValue {
            var report = Report()
            report.title = answer["title"].stringValue
            report.content = answer["content"].dictionaryValue
            report.type = answer["type"].stringValue
            reports.append(report)
            print(report.content)
        }
        questionTitleLabel.text! = reports[i].title
        
        print(reports.count)
    }
    
    
    func setupChart(type:String,i : Int){
        if tempView != nil{
            tempView.removeFromSuperview()
        }
        switch type {
        case "QUESTION_TEXT" , "QUESTION_PARAGRAPH" :
          
            var entries : [BarChartDataEntry] = []
            var j = 1
            for (key,value) in reports[i].content{
                entries.append(BarChartDataEntry(x: Double(j), y: JSON(value).doubleValue))
                j+=1
            }
            let dataset = BarChartDataSet(entries: entries, label: reports[i].title)
            let data = BarChartData(dataSets: [dataset])
            let chart = chartView
            chart?.data = data
            chart?.chartDescription?.text = reports[i].title
            dataset.colors = ChartColorTemplates.vordiplom()
            chart?.animate(yAxisDuration: 0.5)
            chart?.notifyDataSetChanged()
            parentView.addSubview(chart!)
            tempView = chartView as! BarChartView
            
            break
        case "QUESTION_RADIO_GROUP" , "QUESTION_SLIDER" , "QUESTION_DROPDOWN" , "QUESTION_RATING" :
         
            var j = 0.0
            var entries : [ChartDataEntry] = []
            for (key,value) in reports[i].content{
                entries.append(ChartDataEntry(x: j, y: JSON(value).doubleValue))
                j += 1
            }
            let dataset = LineChartDataSet(entries: entries, label: reports[i].title)
            let data = LineChartData(dataSets: [dataset])
            let chart = lineChart
            chart?.data = data
            chart?.chartDescription?.text = "Single Choice"
            chart?.animate(yAxisDuration: 0.5)
            chart?.animate(yAxisDuration: 0.4)
            chart?.notifyDataSetChanged()
            parentView.addSubview(chart!)
            tempView = lineChart as! LineChartView
            break
            
        case "QUESTION_CHECKBOX":
          
            var entries : [PieChartDataEntry] = []
            for (key,value) in reports[i].content{
                entries.append(PieChartDataEntry(value: JSON(value).doubleValue, label: key))
            }
               let dataset = PieChartDataSet(entries: entries, label: reports[i].title)
            let data = PieChartData(dataSets: [dataset])
            dataset.colors = [UIColor.flatRed() , UIColor.flatYellow() , UIColor.flatOrange()]
            let chart = pieChartView
            chart?.data = data
            chart?.chartDescription?.text = "Multiple Choice"
            chart?.animate(yAxisDuration: 0.4)
            chart?.animate(xAxisDuration: 0.4)
            chart?.notifyDataSetChanged()
            parentView.addSubview(pieChartView)
            tempView = pieChartView  as? PieChartView
            
            break
        case "QUESTION_RANGE":
            if tempView != nil{
                tempView.removeFromSuperview()
            }
            var j = 0.0
            var entries : [BubbleChartDataEntry] = []
            for (key,value) in reports[i].content{
                entries.append(BubbleChartDataEntry(x: j, y: value.doubleValue, size: 0.5))
                j += 1
            }
            let dataset = BubbleChartDataSet(entries: entries, label: reports[i].title)
            let data = BubbleChartData(dataSets: [dataset])
            dataset.colors = [UIColor.flatRed() , UIColor.flatYellow() , UIColor.flatOrange()]
            let chart = bubbleChart
            chart?.data = data
            chart?.chartDescription?.text = "Range Choice"
            chart?.animate(yAxisDuration: 0.4)
            chart?.animate(xAxisDuration: 0.4)
            chart?.notifyDataSetChanged()
            parentView.addSubview(bubbleChart)
            tempView = bubbleChart as BubbleChartView
            
            break
        default:
            if tempView != nil{
                tempView.removeFromSuperview()
            }
            return
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

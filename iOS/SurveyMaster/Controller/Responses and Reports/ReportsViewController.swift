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
    var i = -1
    @IBOutlet var chartView: UIView!
    
    @IBOutlet var previousBtn: UIButton!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var questionTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest(url: ShowSurveysURL+"/\(Sid)/report")
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
                        print(json.arrayValue)
                        group.leave()
                    }
                }
        }
        
    }
    
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
          if !reports.isEmpty  {
            
        
        i += 1
  
        
        if i == reports.count  {
            i = 0
        }
        
        questionTitleLabel.text! = reports[i].title
        setupChart(type: reports[i].type, i: i)
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
        print(reports.count)
    }
    
    
    func setupChart(type:String,i : Int){
        switch type {
        case "QUESTION_TEXT":
            var entries : [BarChartDataEntry] = []
            var j = 1
            for (key,value) in reports[i].content{
                entries.append(BarChartDataEntry(x: Double(j), y: JSON(value).doubleValue))
                j+=1
            }
            let dataset = BarChartDataSet(entries: entries, label: reports[i].title)
            let data = BarChartData(dataSets: [dataset])
            var chart = chartView as! BarChartView
            chart.data = data
            chart.chartDescription?.text = reports[i].title
            dataset.colors = ChartColorTemplates.vordiplom()
            chart.notifyDataSetChanged()
            break
       // case "Q":
        default:
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

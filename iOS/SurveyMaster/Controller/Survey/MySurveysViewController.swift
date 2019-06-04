//
//  MySurveysViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/3/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GSMessages
import SwiftMoment
import ChameleonFramework

class MySurveysViewControl: UITableViewController {
    let defaults = UserDefaults.standard
    var surveys = [Survey]()
    override func viewDidLoad() {
        super.viewDidLoad()
        validatingSession()
//
     tableView.register(UINib(nibName:"SurveyItemTableViewCell" , bundle: nil), forCellReuseIdentifier: "SurveyItemViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        // Do any additional setup after loading the view.
    }
    
    func validatingSession() {
        let header = [
            "x-auth-token" : defaults.string(forKey: "token")
        ]
        Alamofire.request(ShowSurveysURL, method: .get,parameters: nil, encoding: JSONEncoding.default, headers: header as! HTTPHeaders)
            .responseJSON{
                response in
                if response.result.isSuccess{
                    if let response = response.result.value {
                        let data = JSON(response).arrayValue
                        
                        self.updateSurveyObject(data:data)
                       // print("response" ,response)
                    }
                    
                }
                else{
                    self.showMessage("error Happenend", type: .error)
                }

            
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyItemViewCell", for: indexPath) as! SurveyItemTableViewCell
        return configureTableViewCell(cell: cell, index: indexPath)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return surveys.count
    }
    func updateSurveyObject(data: [JSON]){
        for item in data{
          var survey = Survey()
            survey.title = item["title"].stringValue
           // survey.description = item["description"].stringValue
            survey.description = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
            survey.date = item["date"].int
            survey.link = item["link"].stringValue
            surveys.append(survey)
            tableView.reloadData()
        }
        
        
    }
    //MARK :- configuring table view cell
    func configureTableViewCell (cell : SurveyItemTableViewCell,index: IndexPath) -> SurveyItemTableViewCell{
        let mysurvey = surveys[index.row]
        cell.titleLabel.text = mysurvey.title
        
        let date = moment(mysurvey.date!)
        let dateString = " \(date.day)-\(date.month)-\(date.year)"
        cell.DateLabel.text! = dateString
        cell.selectionStyle =  UITableViewCell.SelectionStyle.none
        cell.colorView.backgroundColor = UIColor.randomFlat()
        cell.descriptionLabel.text = mysurvey.description
        return cell
    }
}

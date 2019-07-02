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
 
    var surveys = [Survey]()

    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refresh),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.gray

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        validatingSession()
        //self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refresher

        setupTableViewCell()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func refresh(){
       // refreshControl?.beginRefreshing()
        validatingSession()
        //tableView.reloadData()
        refreshControl?.endRefreshing()
    }
     func validatingSession() {
      
        Alamofire.request(ShowSurveysURL, method: .get,parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders)
            .responseJSON{
                response in
             //   print(response)
                if response.result.isSuccess{
                    if let response = response.result.value {
                        let data = JSON(response).arrayValue
                        
                        self.updateSurveyObject(data:data)
                       // print("response" ,response)
                    }
                    
                }
                else{
                    print(response)
                    self.showMessage("error Happenend check your connection", type: .error)
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
    //MARK:- configuring json
    func updateSurveyObject(data: [JSON]){
        for item in data{
            let survey = Survey()
            survey.id = item["_id"].stringValue
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
        surveys.reverse()
        let mysurvey = surveys[index.row]
        cell.titleLabel.text = mysurvey.title
        let colors : [UIColor] = [UIColor.flatGrayColorDark(),UIColor.flatNavyBlueColorDark(),UIColor.flatCoffeeColorDark()]
        let random = arc4random_uniform(2)
        let date = moment(mysurvey.date!)
        let dateString = " \(date.day)-\(date.month)-\(date.year)"
        cell.DateLabel.text! = dateString
//cell.selectionStyle =  UITableViewCell.SelectionStyle.none
        
        cell.colorView.backgroundColor = colors[Int(random)]
        cell.descriptionLabel.text = mysurvey.description
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "responsesSegue" {
//            if let segue = segue.destination as? ResponseReportsViewController {
//                       // segue.delegate = self
//                if let cell = sender as? SurveyItemTableViewCell,let indexPath = tableView.indexPath(for: cell) {
//                    let id = surveys[indexPath.row].id
//                    segue.Sid = id ?? "no id"
//                    print(segue.Sid)
//                }
//            }
//        }
//    }
    
    
    
    
    // MARK :- did select row at
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "responsesSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Deleting Survey", message: "there's no step back, are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (alert) in
            let totalIndices = self.surveys.count - 1 // We get this value one time instead of once per iteration.
            
            var reversedSurveys = [Survey]()
            
            for arrayIndex in 0...totalIndices {
                reversedSurveys.append(self.surveys[totalIndices - arrayIndex])
            }
            self.deleteRequest(tableView: tableView, for: indexPath,surveys:reversedSurveys )
            self.surveys.reverse()
            print(reversedSurveys[indexPath.row].id!)
            self.surveys.remove(at: indexPath.row )
            self.validatingSession()
        }))
        self.present(alert,animated: true)
     
    }
    
    // MARK :- Setup table view
    func setupTableViewCell(){
        tableView.register(UINib(nibName:"SurveyItemTableViewCell" , bundle: nil), forCellReuseIdentifier: "SurveyItemViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
//        tableView.addSubview(refreshControl!)
    }

    func deleteRequest(tableView : UITableView,for indexPath: IndexPath,surveys: [Survey]){
        let url = DeleteURL + surveys[indexPath.row].id!
        print(surveys[indexPath.row].id!)
        print(surveys[indexPath.row].title!)
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header as! HTTPHeaders)
            .responseString {
                response in
                print(response.request)
                if response.result.isSuccess{
                   if let statusCode = response.response?.statusCode{
                    print("status code",statusCode)
                    if statusCode == 200 {
                        SVProgressHUD.showSuccess(withStatus: "Survey was deleted successfully")
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                    }
                }
                    
                
        }
    }

}

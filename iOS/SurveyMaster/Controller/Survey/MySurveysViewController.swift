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
import RealmSwift

class MySurveysViewControl: UITableViewController {
    var tempSurveys = [Survey]()
    var surveys = [Survey]()
    var storedSurveys = [Survey]()
    let realm = try! Realm()
  var length = 0
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refresh),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.flatWhite()

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        validatingSession(loader: true)
      
        tableView.refreshControl = refresher
//        
        setupTableViewCell()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
    }
    @objc func refresh(){
     //   surveys = []
       // refreshControl?.beginRefreshing()
        validatingSession(loader:false)
        //tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    func validatingSession(loader: Bool) {
        if loader {
             SVProgressHUD.show(withStatus: "Fetching data...")
        }
        let group = DispatchGroup()
        group.enter()
      
        Alamofire.request(ShowSurveysURL, method: .get,parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders)
            .responseJSON{
                response in
               
                if response.result.isSuccess{
                    if let response = response.result.value {
                        let data = JSON(response).arrayValue
                        if data.count == self.tempSurveys.count {
                             SVProgressHUD.dismiss()
                            return
                        }
                        self.updateSurveyObject(data:data,loader:loader)
                        SVProgressHUD.dismiss()
                       // print("response" ,response)
                  
                    }
                    
                }
                else{
                    SVProgressHUD.dismiss()
                    print(response)
                    self.showMessage("Error happenend check your connection", type: .error)
                    do {
                        self.surveys = try Array(self.realm.objects(Survey.self))
                        self.updateLocally(arr: self.surveys)
                        
                    }
                    catch{}
                }
                      group.leave()

            
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
    func updateSurveyObject(data: [JSON],loader: Bool){
        surveys = []
        
        do{
            storedSurveys = Array(realm.objects(Survey.self))
            for survey in storedSurveys{
               try realm.write {
                    try realm.delete(survey)
                }
            }
        }
        catch {}
        
        
        for item in data{
            let survey = Survey()
            survey.id = item["_id"].stringValue
            survey.title = item["title"].stringValue
           // survey.description = item["description"].stringValue
            survey.descriptions = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
            survey.date = item["date"].int
            survey.link = item["link"].stringValue       
            surveys.append(survey)
            tableView.reloadData()
            do {
               
                try realm.write {
                    realm.add(survey)
                }
            }
            catch{}
            
        
             }
      
        
        tempSurveys = surveys
        
        
    }
    func updateLocally(arr: [Survey]){
        surveys = []
        
        for item in arr{
            let survey = Survey()
            survey.id = item.id
            survey.title = item.title
            // survey.description = item["description"].stringValue
            survey.descriptions = item.descriptions
            survey.date = item.date
            survey.link = item.link
            surveys.append(survey)
            tableView.reloadData()
           
            
        }
        
        
        tempSurveys = surveys
    }
    //MARK :- configuring table view cell
    func configureTableViewCell (cell : SurveyItemTableViewCell,index: IndexPath) -> SurveyItemTableViewCell{
//        do{
//            if let surveys = try realm.objects(surveys.self){
//
//            }
//        }catch{}
       
        surveys.reverse()
        let mysurvey = surveys[index.row]
        cell.titleLabel.text = mysurvey.title
        let colors : [UIColor] = [UIColor.flatGrayColorDark(),UIColor.flatNavyBlueColorDark(),UIColor.flatCoffeeColorDark()]
        let random = arc4random_uniform(2)
        let date = moment(mysurvey.date ?? 0)
        let dateString = " \(date.day)-\(date.month)-\(date.year)"
        cell.DateLabel.text! = dateString
        cell.colorView.backgroundColor = colors[Int(random)]
        cell.descriptionLabel.text = mysurvey.descriptions
        return cell
    }

    
    
    //MARK:- leading swipe action
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fill = UIContextualAction(style: .normal, title: "") { (action, view, nil) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UIViewController-osB-UH-js5") as? FillViewController
            vc?.SurveyID = self.surveys[indexPath.row].id!
            print( self.surveys[indexPath.row].id!)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        fill.image = UIImage(named: "edit-file")
        fill.backgroundColor = UIColor(hexString: "#1c2938")
        let share = UIContextualAction(style: .normal, title: "") { (action, view, nil) in
            let shareLink = "https://192.168.1.1:5000" + self.surveys[indexPath.row].link!
            let activity = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
            self.present(activity,animated: true)

           
        }
        share.image = UIImage(named: "share")
        share.backgroundColor = UIColor(hexString: "216583")
        let config = UISwipeActionsConfiguration(actions: [fill,share])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let qrCode = UIContextualAction(style: .destructive,title: "") { (action, view, nil) in
            let popOverVC = UIStoryboard(name: "FillAndReports", bundle: nil).instantiateViewController(withIdentifier: "popUpViewController") as! PopUpViewController
            popOverVC.SurveyID = self.surveys[indexPath.row].id!
            
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(popOverVC, animated: true)
        }
        qrCode.backgroundColor = .orange
        qrCode.image = UIImage(named: "qr-code")
        //// delete
        
        
        let delete = UIContextualAction(style: .destructive, title:"") { (action, view, nil) in
           self.deleteButtonAction(tableView,indexPath)
        }
        delete.image = UIImage(named: "clear")
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete,qrCode])
    }
    // MARK:- did select row at
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "ResponsesViewController") as? ResponsesViewController
        vc?.Sid = surveys[indexPath.row].id!
        vc?.SName = surveys[indexPath.row].title!
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    func deleteButtonAction(_ tableView: UITableView ,_ indexPath: IndexPath){
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
            //print(reversedSurveys[indexPath.row].id!)
            self.surveys.remove(at: indexPath.row )
            self.validatingSession(loader : false)
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
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders)
            .responseString {
                response in
               // print(response.request)
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

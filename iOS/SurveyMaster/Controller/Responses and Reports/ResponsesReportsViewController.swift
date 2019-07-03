//
//  ResponsesReportsViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/3/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftHTTP
class ResponsesReportsViewController: UIViewController {
    
    var R_id : String = ""
    var S_id : String = ""
    var responseContent: [ResponseContent] = []
    var numofChoices : Int = 0
    
    @IBOutlet var ResRepTableView: UITableView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ResRepTableView.delegate = self
        ResRepTableView.dataSource = self
        ResRepTableView.register(UINib(nibName: "ReportResponseTableViewCell", bundle: nil), forCellReuseIdentifier: "responseCell")
    
//        let group = DispatchGroup()
//        group.enter()
        HTTP.GET(ShowSurveysURL+"/\(S_id)/responses/\(R_id)", parameters: nil, headers: header as! [String : String], completionHandler: {
            response in
            print(response.URL)
            print(response)
            
                    self.updateResponseContent(json: JSON(response.data))
            
               // group.leave()
            
        })
//        group.notify(queue: DispatchQueue.main) {
//            print("Goodbye, world!")
//            //exit(0)
//        }
     
        
        }
   
    
    
    func updateResponseContent(json: JSON){
        let answers = json["answers"]
        print(answers)
        for answer in answers.arrayValue {
            print(answer["content"]["choices"].stringValue)
            var responseContent = ResponseContent()
            responseContent.choices = answer["content"]["choices"].arrayValue.compactMap({
                $0.stringValue
            })
            responseContent.valueString = answer["content"]["value"].stringValue
            responseContent.type = answer["type"].stringValue
            responseContent.title = answer["question"]["title"].stringValue
            print(responseContent.type , responseContent.title ,responseContent.valueString ,responseContent.choices)
            ResRepTableView.reloadData()
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
extension ResponsesReportsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(responseContent.count)
        if responseContent.count > 0 {
            if responseContent[section].isOpened {
                return  responseContent[section].choices.count
            }
            else {
                return 1
            }
        }
        else {return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "responseCell", for: indexPath) as! ReportResponseTableViewCell 
        if responseContent[indexPath.row].type == "ANSWER_TEXT" {
              cell.textLabel?.text! = responseContent[indexPath.row].valueString
        }
        else {
            cell.textLabel?.text! = responseContent[indexPath.section].choices[indexPath.row]
        }
//        
        return cell
    }
    
    
}

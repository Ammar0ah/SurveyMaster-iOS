//
//  ResponseReportsViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/2/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMoment
class ResponsesViewController: UIViewController {
    
    var Sid : String = "ss"
    var SName : String = ""
    var jsonList : [JSON] = []
    var responses : [Response] = []
    
    @IBOutlet var responsesTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
   print(Sid)
// Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = false
        responsesTableview.delegate = self
        responsesTableview.dataSource = self
        responsesTableview.estimatedRowHeight = UITableView.automaticDimension
        responsesTableview.estimatedRowHeight = 100
        let group = DispatchGroup()
        group.enter()
        Alamofire.request(ShowSurveysURL + "/\(Sid)" + "/responses/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON{
            response in
           
            if response.result.isSuccess {
                if let response = response.result.value {
                    self.jsonList = JSON(response).arrayValue
                    print(self.jsonList)
                    self.configureResponses(data: self.jsonList)
                    group.leave()
                }
              
            }
        }
    }
    
    func configureResponses(data:[JSON]){
        for item in data {
            let response = Response()
            response.date = item["date"].intValue
            response.surveyId = item["surveyId"].stringValue
            response.responseId = item["_id"].stringValue
            responses.append(response)
            responsesTableview.reloadData()
            print(response.surveyId)
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
//
extension ResponsesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count",responses.count)
        return responses.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         let date = moment(responses[indexPath.row].date)
         let dateString = " \(date.day)-\(date.month)-\(date.year)"
        cell.textLabel?.text! = "Response: \(indexPath.row + 1)"
        cell.detailTextLabel?.text! = dateString
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ReportsViewController") as? ReportsViewController else {return}
        
        print("survey id", responses[indexPath.row].surveyId)
         VC.Sid = responses[indexPath.row].surveyId
         //VC.R_id = responses[indexPath.row].responseId
        self.navigationController?.pushViewController(VC, animated: true)
       
        
    }


}

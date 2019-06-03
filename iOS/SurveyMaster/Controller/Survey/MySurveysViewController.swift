//
//  MySurveysViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/3/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
class MySurveysViewController: UIViewController {
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        validatingSession()
        // Do any additional setup after loading the view.
    }
    
    func validatingSession() {
        let header = [
            "x-auth-token" : defaults.string(forKey: "token")
        ]
        Alamofire.request(ShowSurveysURL, method: .get,parameters: nil, encoding: JSONEncoding.default, headers: header as! HTTPHeaders)
            .responseString{
                response in
                print("response" ,response.result.value)
            
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

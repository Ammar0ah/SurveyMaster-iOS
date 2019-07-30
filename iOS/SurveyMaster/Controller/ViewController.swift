//
//  ViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import Wrap
import SwiftyJSON
class ViewController: UIViewController {
    let defaults = UserDefaults.standard
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if defaults.string(forKey: "token") != nil{
           
            performSegue(withIdentifier: "WelcomeToView", sender: self)
        }
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
       
        navigationController?.setNavigationBarHidden(true, animated: true)
    }


}

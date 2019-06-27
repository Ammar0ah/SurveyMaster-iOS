//
//  ViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    let slider = SliderQuestion("title","desc")
    override func viewDidLoad() {
        
        super.viewDidLoad()
        slider.setJSON(slider)
        if defaults.string(forKey: "token") != nil{
           
            performSegue(withIdentifier: "WelcomeToView", sender: self)
        }
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
       
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}


//
//  LoginViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
class LoginViewController: UIViewController {
    let user = User()
    let defaults = UserDefaults.standard
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.text = "ammar@helali.com"
        passwordTxt.text = "123123123"

      
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

  
   
    @IBAction func loginBtn(_ sender: Any) {
        
        let params = ["email":emailTxt.text! ,"password":passwordTxt.text!]
        
        Alamofire.request(LoginURL, method: .post, parameters:params,encoding: JSONEncoding.default)
            .responseString{
                response in
                SVProgressHUD.show()
                if response.result.isSuccess{
                    let statusCode = response.response?.statusCode
                    if(statusCode == 400)
                    {
                        SVProgressHUD.showError(withStatus:response.result.value)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                    else if let response = response.result.value {
                        self.defaults.set(response, forKey: "token")
                        self.performSegue(withIdentifier: "LoginToView", sender: self)
                    }
                    
                }
                else {
                        if let data = response.data {
                        let error = String(data: data, encoding: String.Encoding.utf8)
                      
                            SVProgressHUD.showError(withStatus:error == "" ? "couldn't connect to the server": error)
                            SVProgressHUD.dismiss(withDelay: 1.5)
                       
                    }
                    
                }
                SVProgressHUD.dismiss(withDelay:0.5)
        }
    }
  
}

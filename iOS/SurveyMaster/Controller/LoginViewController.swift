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
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.text = "ammar@helali.com"
        passwordTxt.text = "123123123"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    @IBAction func loginBtn(_ sender: Any) {
        
        let params = ["email":emailTxt.text! ,"password":passwordTxt.text!]
        
        Alamofire.request(LoginURL, method: .post, parameters:params,encoding: JSONEncoding.default)
            .responseJSON{
                response in
                SVProgressHUD.show()
                if response.result.isSuccess{
                    if let response = response.result.value {
                        let responseJSON = JSON(response)
                        print(response)
                        self.updateUserData(json: responseJSON )
                    }
                    
                }
                else {
                        if let data = response.data {
                        let error = String(data: data, encoding: String.Encoding.utf8)
                            
                        if error!.contains("email")
                        {
                            SVProgressHUD.showError(withStatus:error)
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                        else {
                            self.performSegue(withIdentifier: "LoginToView", sender: self)
                        }
                    }
                    
                }
                SVProgressHUD.dismiss(withDelay:0.5)
        }
    }
    func updateUserData(json:JSON)
    {
        print("I'm in")
        if  json["email"].string != nil{
            user.email = json["email"].string!
            performSegue(withIdentifier: "LoginToView", sender: self)
        }
            
        else{
            SVProgressHUD.showError(withStatus: json[0].string!)
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
        
        
    }
}

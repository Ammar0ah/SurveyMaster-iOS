//
//  RegisterViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GSMessages
class RegisterViewController: UIViewController {
    var user = User()
    var defaults = UserDefaults.standard
    @IBOutlet weak var firstNameTxtField: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTxtField.text = "ammar"
        lastNameTxt.text = "helali"
        emailTxt.text = "ammar@helali.com"
        passwordTxt.text = "123123123"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func registerBtn(_ sender: Any) {
        
        if(passwordTxt.text!.count < 8)
        {
            SVProgressHUD.showInfo(withStatus: "Password length must be 8 characters at least! ")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        
        let params = ["firstName": firstNameTxtField.text! , "lastName" : lastNameTxt.text! ,"email":emailTxt.text! ,"password":passwordTxt.text!]
       
        Alamofire.request(RegistationURL, method: .post, parameters:params,encoding: JSONEncoding.default)
            .responseJSON{
                response in
                SVProgressHUD.show()
                if response.result.isSuccess{
                    if let response = response.result.value {
                        let responseJSON = JSON(response)
                        self.updateUserData(json: responseJSON,error : responseJSON[0].string ?? "" )
                     
                            }
                    if let token = response.response?.allHeaderFields["x-auth-token"] as? String{
                        self.defaults.set(token, forKey: "token")
                    }
                }
                else {
                        if let data = response.data {
                        let error = String(data: data, encoding: String.Encoding.utf8)
                          SVProgressHUD.showError(withStatus:error)
                          SVProgressHUD.dismiss(withDelay: 1)
                    }
                }
                SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
    
    func updateUserData(json:JSON,error:String)
    {
        if let id = json["_id"].string{
        user._id = json["_id"].string!
         user.firstName = json["firstName"].string!
         user.lastName  = json["lastName"].string!
        user.email = json["email"].string!
        performSegue(withIdentifier: "RegisterToView", sender: self)
        }
           
        else{
            if !error.contains("_id"){
            SVProgressHUD.showError(withStatus: error)
            SVProgressHUD.dismiss(withDelay: 1.5)
            }
            }
  
    
    }
  

}

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
                if response.result.isSuccess{
                    if let response = response.result.value {
                        
                        let responseJSON = JSON(response)
                        print(response)
                        self.updateUserData(json: responseJSON )
                        
                    }
                    
                }
                else {
                    print(response.error)
                  //  SVProgressHUD.showError(withStatus:response.result as! String)
                }
        }
    }
    func updateUserData(json:JSON)
    {
        if   emailTxt.text! != "" || passwordTxt.text! != "" {
            user.email = json["email"].string!
            performSegue(withIdentifier: "RegisterToView", sender: self)
        }
            
        else{
            SVProgressHUD.showError(withStatus: "Invalid input, fix your inputs and try again")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
        
        
    }
}

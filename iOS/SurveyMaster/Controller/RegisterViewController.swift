//
//  RegisterViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTxtField: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func registerBtn(_ sender: Any) {
        
        Alamofire.request("\(getSurveysURL)api/surveys", method: .get, parameters: nil)
            .responseJSON{
                response in
                if response.result.isSuccess{
                    print(response.result.value!)
                }
                else {
                    print("Failed")
                }
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

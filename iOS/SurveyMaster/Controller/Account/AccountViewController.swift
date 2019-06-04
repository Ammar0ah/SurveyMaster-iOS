//
//  AccountViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/4/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import SVProgressHUD

class AccountViewController: UIViewController {
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        defaults.removeObject(forKey: "token")
        
        presentingViewController?.dismiss(animated: true, completion: {
          SVProgressHUD.showSuccess(withStatus: "Logged out successfully")
            SVProgressHUD.dismiss(withDelay: 1)
        })
     
    
        
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

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
//    //    let content = SliderQuestion.content(0,10)
//        var slider = SliderQuestion("hey","hho")
//
//
//
//        let question = CreateItem(title: "First Fuckin Survey",pages: [QuestionsArray(questions: [Questions(title: "First Fuckin Title", type: "QUESTION_SLIDER", content: Content())])])
//        do{
//            var wrapper = try wrap(slider)
//            print(JSON(wrapper))
//
//        }
//        catch{
//
//        }
   //      let slider = SliderQuestion("MyTitle","Mydesc")
//         slider.content = content
//    
//        Question.Questions.append(slider)
//        slider.postData()
        if defaults.string(forKey: "token") != nil{
           
            performSegue(withIdentifier: "WelcomeToView", sender: self)
        }
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
       
        navigationController?.setNavigationBarHidden(true, animated: true)
    }


func post(data: JSON)
{
    let header = [
        "x-auth-token" : defaults.string(forKey: "token")
    ]
    
    Alamofire.request(PostURL, method: .post, parameters:data.dictionaryObject, encoding: JSONEncoding.default , headers: header as? HTTPHeaders)
        .responseJSON{
            response in
            if response.result.isSuccess{
                print("SUCCESS")
                print(response)
            }
            else {
                print(response.result)
            }
            
    }
   
}
}

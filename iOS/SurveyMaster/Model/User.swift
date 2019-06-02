//
//  User.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/2/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class User {
    var _id : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
  
    
    
    public convenience init(first:String , last: String , email: String ) {
       self.init()
        firstName = first
        lastName = last
        self.email = email
      
    }
    public convenience init (email: String ) {
        self.init()
        self.email = email
        
        
    }

}

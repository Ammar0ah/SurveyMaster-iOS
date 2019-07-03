//
//  Response.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/2/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import SwiftyJSON

class Response {
    var responseId : String = ""
    var surveyId : String = ""
    var date : Int = 0

}

struct ResponseContent {
   var  valueString : String
    
    var choices : [String]
    var title : String
    var type : String
    var isOpened : Bool
    init() {
        valueString = ""
        choices = []
        title = ""
        type = ""
        isOpened = false
    }
}

struct Report {
    var title : String
    var content : [String : JSON]
    var type : String
    init() {
        title = ""
        content = [:]
        type = "" 
    }
}

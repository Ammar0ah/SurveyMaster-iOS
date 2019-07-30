//
//  Question.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/25/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Question {
    var _id : String?
    var title : String
    var type: String
    var isActive : Bool?
    var content : Content = Content()
    //static var questions : [Question] = []
    init(_ title: String , _ type: String) {
        self.title = title
        self.type = type
        
    }

}


struct Questions {
    var title : String
    var type : String
    var content : Content
}
struct Content{
    var min : Int?
    var max : Int?
    var minLabel : String?
    var maxLabel : String?
    var defaultValue : Int?
    var step : Int?
    var choices : [String]?
    var value : String?
    init(min: Int? = nil ,max: Int? = nil , minLabel: String? = nil , maxLabel: String? = nil,defalt:Int? = nil , step:Int? = nil ,choices: [String]? = nil,value: String? = nil) {
        self.min = min
        self.max = max
        self.choices = choices
        self.defaultValue = defalt
        self.maxLabel = maxLabel
        self.minLabel = minLabel
    }
}
struct CreateItem {
    var title : String
    var pages : [QuestionsArray]
    init(title: String , pages:[QuestionsArray]) {
        self.title = title
        self.pages = pages
    }
}
struct QuestionsArray {
    var questions : [Questions]
}

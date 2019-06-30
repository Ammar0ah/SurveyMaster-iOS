//
//  SliderQuestion.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/25/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import SwiftyJSON
import Wrap

class SliderQuestion : Question {
    var content = Content (min:4,max:10,minLabel: "min",maxLabel: "max", defaultValue: 5,step:3)
    override init(_ title: String, _ type: String) {
       super.init(title, type)
    }
}


struct Questions {
    var title : String
    var type : String
    var content : Content
}
struct Content{
    var min : Int
    var max : Int
    var minLabel : String
    var maxLabel : String
    var defaultValue : Int
    var step : Int
}
struct CreatItem {
    var title : String
    var pages : [QuestionsArray]
}
struct QuestionsArray {
    var questions : [Questions]
}

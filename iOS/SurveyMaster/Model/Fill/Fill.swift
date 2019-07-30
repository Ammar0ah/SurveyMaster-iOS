//
//  Fill.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/17/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation

struct Fill {
    var surveyId : String
    var answers : [Answer]
}


class Answer{
    var questionId : String
    var type: String
    var content : Content
    init(qId : String , type : String , content: Content) {
        questionId = qId
        self.type = type
        self.content = content
    }
    
}

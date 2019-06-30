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
     var types : [String]
    var title : String
    var type: String
    static var questions : [Question] = []
    init(_ title: String , _ type: String) {
        self.title = title
        self.type = type
        self.types = ["short text", "slider"]
    }

}

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
    static var types : [String] {
        get {return ["short text", "slider"]}
    }
    static var Questions : [Question] = []
    static var QuestionsJSON : [JSON] = []
    var title : String?
    var description: String?
    init(_ title: String , _ desc: String) {
        self.title = title
        self.description = desc
    }
    
}

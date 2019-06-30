//
//  RangeQuestion.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/25/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
public class RangeQuestion : Question {
  
    var content = Content()
     struct Content {
        var min : Int?
        var max : Int?
        var minLabel : Int?
        var maxLabel : Int?
        var minDefaultValue : Int?
        var maxDefaultValue : Int?
        var step : Int?
    }
//    override init(_ title : String , _ description : String) {
//        super.init(title, description)
//    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    func setInfo(cell: Any) {
        
    }
    func setJSON (cell: Any){
        
    }
    
}

//
//  SliderQuestion.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/25/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import SwiftyJSON
class SliderQuestion : Question {
    var content = Content()
    struct Content {
        var min : Int?
        var max : Int?
        var minLabel : String?
        var maxLabel : String?
        var defaultValue : Int?
        var step : Int?
    }
    override init(_ title: String, _ desc: String) {
        super.init(title, desc)
    }
    func setValues(_ cell : SliderTableViewCell){
        content.min  = Int(cell.min ?? 0)
        content.max = Int(cell.max ?? 10)
        
        
    }
    func setJSON(_ slider: SliderQuestion){
        
        slider.content.min = 5
        slider.content.max = 6
        slider.content.defaultValue = 0
        print(JSON(slider))
 
    }
}




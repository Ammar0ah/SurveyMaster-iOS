//
//  Survey.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/4/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
public class Survey : Object{
  @objc dynamic var id : String?
  @objc dynamic var title : String?
     dynamic var date : Int?
  @objc dynamic var descriptions : String?
  @objc dynamic var link : String?
   dynamic var isActivated : Bool?
  var questions : [Question]?
}

struct postItem {
    var surveyId: String?
    var answers : [Question]
}

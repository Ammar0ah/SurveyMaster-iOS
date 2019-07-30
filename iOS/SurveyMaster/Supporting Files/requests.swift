//
//  requests.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
let defaults = UserDefaults.standard

let baseURL = "https://survey-master-v1.herokuapp.com/"//http://192.168.43.179:5000/" "//"https://survey-master-server.herokuapp.com/" //"http://192.168.1.5:5000/"
let RegistationURL = baseURL + "api/users"
let LoginURL = baseURL + "api/auth"
let ShowSurveysURL = baseURL + "api/surveys"
let PostURL = baseURL + "api/surveys"
let header = [
    "x-auth-token" : defaults.string(forKey: "token")
]  
let DeleteURL =  baseURL + "api/surveys/"

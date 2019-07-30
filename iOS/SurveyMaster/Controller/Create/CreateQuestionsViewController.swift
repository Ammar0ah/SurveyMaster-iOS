//
//  CreateQuestionsTableViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Wrap
import SwiftyJSON


class CreateQuestionsViewController: UIViewController{
    
    @IBOutlet var titleTxt: UITextField!
    
    var types : [String]?
    var questions : [Question] = []
    var slider : SliderQuestion
    var pickerData : [String]
    var questionsList : [String]
    var value : String
    var question: Question
    var bools : [Bool]
    required init?(coder aDecoder: NSCoder) {
        question = Question("Question", "short Text")
        questionsList = []
        pickerData = []
        value = "text"
        slider = SliderQuestion("Title", "type")
        bools = []
        self.types = ["slider","short text","paragraph","checkbox","radioGroup","range","rating","dropDown"]
        super.init(coder: aDecoder)
        
    }
    
    @IBOutlet var surveyTitleTxt: UITextField!
    
    @IBOutlet var questionsTableView: UITableView!
    
    @IBOutlet var QTypesPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setup()
        
        
    }
    
    @IBAction func DoneBtn(_ sender: Any) {
        var questionsStructList : [Questions] = []
        for question in questions {
            
            let createItem = Questions(title: question.title, type: question.type, content: question.content)
            questionsStructList.append(createItem)
        }
        let createItem : CreateItem = CreateItem(title: titleTxt.text!,pages: [QuestionsArray(questions: questionsStructList)])
        //        let createJson = CreateItem(title: titleTxt.text!, pages: QuestionsArray(questions: questions))
        var jsonDictionary : JSON = JSON()
        do{
            let wrapper = try wrap(createItem)
            jsonDictionary = JSON(wrapper)
            print(jsonDictionary)
        }
        catch{
            print("couldn't wrap")
        }
        let action = UIAlertController(title: "Are you sure", message: "select", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "ok", style: .default, handler:{alert in
            Alamofire.request(PostURL, method: .post, parameters: jsonDictionary.dictionaryObject , encoding: JSONEncoding.default, headers: header as! HTTPHeaders)
                .responseJSON{ response in
                    if response.result.isSuccess {
                        let statusCode = response.response?.statusCode
                            if (statusCode == 200){
                                print(response.result)
                                print(jsonDictionary)
                                SVProgressHUD.showSuccess(withStatus: "Submitted Successfully")
                                 self.navigationController?.popViewController(animated: true)
                            }
                            else if (statusCode == 400){
                                SVProgressHUD.showError(withStatus: "Please fill all input and try again")
                                //SVProgressHUD.dismiss()
                        }
                        print(response.result)
                       
                    }
                    
            }
          
        }))
        present(action, animated: true)
    }
    
    @IBAction func AddBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: questionsList.count, section: 0)
        questionsList.append(value)
        questionsTableView.insertRows(at: [indexPath], with: .automatic)
        questionsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        value = questionsList[indexPath.row]
        
        print(types!)
        return  setupCell(for: value, with: indexPath, tableView: tableView)
    }
    
    func setupCell(for value: String , with indexPath: IndexPath,tableView:UITableView) ->UITableViewCell{
           bools.append(false)
        if(value == "short text" || value == "paragraph" || value == "rating"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextTableViewCell
            if value == "rating"{
                cell.QuestionTypeLabel.text! = "Rating Question"
            }
            else if value == "Paragraph"{
                cell.QuestionTypeLabel.text! = "Paragraph Question"
            }
            cell.returnValue = {
                value in
                   value.isActive = self.bools[indexPath.row]
                if self.value == "short text"{
                    value.type = "QUESTION_TEXT"
                }
                else if self.value == "paragraph"{
                     value.type = "QUESTION_PARAGRAPH"
                }
                else if self.value == "rating"{
                    value.type = "QUESTION_RATING"
                }

                if (indexPath.row + 1) == self.questions.count{
                    self.questions[indexPath.row] = value
                }
                else {
                  self.questions.append(value)
                }
            
            }
            return cell
        }
        if (value == "slider" || value == "range"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath)
                as! SliderTableViewCell
            if value == "range"{
                cell.QuestionTypeLabel.text! = "Range Question"
            }
         
            cell.returnValue = { value in
             value.isActive = self.bools[indexPath.row]
                if self.value == "slider" {
                    value.type = "QUESTION_SLIDER"
                }
                else if self.value == "range"{
                    value.type = "QUESTION_RANGE"
                }
               
                if (indexPath.row + 1) == self.questions.count{
                    self.questions[indexPath.row] = value
                }else{
                     self.questions.append(value)
                }
               
            }
       
            
            return cell
        }
        else if (value == "checkbox" || value == "radioGroup" || value == "dropDown"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxRadioGroupCell", for: indexPath) as! CheckBoxTableViewCell
            
            if value == "checkbox"{
              
                cell.images1.image = UIImage(named:"success")
                cell.images2.image = UIImage(named:"success")
                cell.images.image = UIImage(named:"success")
                cell.QTypeLabel.text = "CheckBox Questions"
                
            }else if value == "radioGroup" {
               
                cell.images1.image = UIImage(named:"radio-on-button")
                cell.images2.image = UIImage(named:"radio-on-button")
                cell.images.image = UIImage(named:"radio-on-button")
                cell.QTypeLabel.text = "Radio Group Questions"
            } else {
              
                cell.images1.image = UIImage(named:"drop-down-arrow")
                cell.images2.image = UIImage(named:"drop-down-arrow")
                cell.images.image = UIImage(named:"drop-down-arrow")
            }
            cell.returnValue = { value in
                   value.isActive = self.bools[indexPath.row]
                if self.value == "checkbox"{
                    value.type = "QUESTION_CHECKBOX"
                }
                else if self.value == "radioGroup"{
                    value.type = "QUESTION_RADIO_GROUP"
                } else {
                    value.type = "QUESTION_DROPDOWN"
                }
                if (indexPath.row + 1) == self.questions.count{
                    self.questions[indexPath.row] = value
                }else{
                    self.questions.append(value)
                }
               // print(value.content.choices?[indexPath.row])
            }
            
            return cell
        }
     
        return UITableViewCell()
        
    }
    
    func setup() {
        QTypesPickerView.dataSource = self
        QTypesPickerView.delegate = self
        QTypesPickerView.selectRow(2, inComponent: 0, animated: true)
        titleTxt.delegate = self
        pickerData = types!
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
        questionsTableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        questionsTableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxRadioGroupCell")
        questionsTableView.rowHeight = UITableView.automaticDimension
        questionsTableView.estimatedRowHeight = 400
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))
        questionsTableView.addGestureRecognizer(tapGesture)
    }
    @objc func tableviewTapped(){
        questionsTableView.endEditing(true)
    }

}

/// MARK:- Configure TableView
extension CreateQuestionsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
             bools[indexPath.row] = true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        questionsList.remove(at: indexPath.row)
        bools.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsList.count
    }
}


/// MARK:- Configure Picker View
extension CreateQuestionsViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        value = pickerData[row]
    }
    
    
}
extension CreateQuestionsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


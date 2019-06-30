//
//  CreateQuestionsTableViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import SVProgressHUD
class CreateQuestionsViewController: UIViewController{
    
    var questions : [Question] = []
    var slider : SliderQuestion
    var pickerData : [String]
    var questionsTypes : [String]
    var value : String
    var question: Question
    required init?(coder aDecoder: NSCoder) {
        question = Question("Question", "short Text")
        questionsTypes = []
        pickerData = []
        value = "text"
        slider = SliderQuestion("Title", "type")
        super.init(coder: aDecoder)
        
    }
    func getValues(minLabel: String, maxLabel: String) {
        slider.content.minLabel = minLabel
        slider.content.maxLabel = maxLabel
        print("delegated")
    }
    @IBOutlet var surveyTitleTxt: UITextField!
    
    @IBOutlet var questionsTableView: UITableView!
    
    @IBOutlet var QTypesPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        QTypesPickerView.dataSource = self
        QTypesPickerView.delegate = self
        
        pickerData = question.types
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
        questionsTableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        questionsTableView.rowHeight = UITableView.automaticDimension
        questionsTableView.estimatedRowHeight = 200
    }
    
    @IBAction func DoneBtn(_ sender: Any) {
        let action = UIAlertController(title: "Are you sure", message: "select", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "ok", style: .default, handler:{alert in
            
              self.navigationController?.popViewController(animated: true)
        }))
        present(action, animated: true)
    }
    
    @IBAction func AddBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: question.types.count, section: 0)
        question.types.append(value)
        questionsTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        value = question.types[indexPath.row]
       
        print(question.types)
       return  setupCell(for: value, with: indexPath, tableView: tableView)
}

    func setupCell(for value: String , with indexPath: IndexPath,tableView:UITableView) ->UITableViewCell{
    if(value == "short text"){
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextTableViewCell
        questions.append(Question("title\(indexPath.row)", "QUESTION_TEXT"))
        cell.selectionStyle =  UITableViewCell.SelectionStyle.none
        cell.returnValue = {
            value in
            self.questions[indexPath.row] = value
            }
        return cell
    }
    if (value == "slider"){
        let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath)
            as! SliderTableViewCell
        questions.append(SliderQuestion("title\(indexPath.row)", "QUESTION_SLIDER"))
        cell.selectionStyle =  UITableViewCell.SelectionStyle.none
        cell.returnValue = { value in
            self.questions[indexPath.row] = value
        }
        
        return cell
    }
    
    return UITableViewCell(style: .default, reuseIdentifier: "textCell")
    
    }
}



/// MARK:- Configure TableView
extension CreateQuestionsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        question.types.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.types.count
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

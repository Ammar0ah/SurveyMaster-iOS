//
//  FillViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/17/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import Wrap
import GSMessages
import SVProgressHUD
class FillViewController: UIViewController {
    var SurveyID : String!
    let survey = Survey()
    var tempView : UIView!
    var questionIndex: Int
    var fill : Fill
    var choices : [String]
    @IBOutlet var questionView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var checkView: UIView!
    ///// checkbox
    @IBOutlet var checkLabel1: UILabel!
    @IBOutlet var checkLabel2: UILabel!
    @IBOutlet var checkLabel3: UILabel!
    @IBOutlet var check1Btn: UIButton!
    @IBOutlet var check2Btn: UIButton!
    @IBOutlet var check3Btn: UIButton!
    //// slider
    @IBOutlet var sliderView: UIView!
    @IBOutlet var sliderLabel: UILabel!
    /// view
    @IBOutlet var textView: UIView!
    @IBOutlet var textArea: UITextView!
    required init?(coder aDecoder: NSCoder) {
        choices = []
        survey.questions = []
        questionIndex = 0
       
        fill = Fill(surveyId: "SurveyID", answers: [])
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // survey.id = ""
        ///init view
        questionView.backgroundColor = UIColor(hexString: "5F4A8D")
        check1Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        check2Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        check3Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        getData()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    
    ///MARK:- get request
    func getData(){
        SVProgressHUD.show(withStatus: "Fetching data...")
        Alamofire.request("\(baseURL)api/surveys/" + SurveyID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header as? HTTPHeaders)
            .responseJSON {
                response in
                if response.result.isSuccess{
                    self.fill.surveyId = self.SurveyID
                    guard let response = response.result.value else {return}
                    self.decodeSurvey(json: JSON(response))
                    SVProgressHUD.dismiss()
                    
                }
                //   print(response.result.value!)
        }
    }
    
    func postData() {
        do{   let params = try wrap(fill)
            Alamofire.request("\(baseURL)fill/" + SurveyID, method: .post, parameters: params , encoding: JSONEncoding.default , headers: header as? HTTPHeaders)
                .responseJSON { (response) in
                    if response.result.isSuccess{
                        SVProgressHUD.showSuccess(withStatus: "Submitted Successfully")
                        self.navigationController?.popViewController(animated: true)
                        SVProgressHUD.dismiss(withDelay: 1)
                    }
                    else {
                         self.showMessage("Error , Check your connection", type: .error)
                    }
                    print(response.result.value! , response.response?.statusCode)
                    
            }
        }
        catch {}
      
    }
    
    
    
    
    @IBAction func nextClicked(_ sender: Any) {
        nextBtn.setTitle("Next", for: .normal)
        if questionIndex > survey.questions!.count - 1  {
            nextBtn.setTitle("Submit", for: .normal)
          
            
        }
        if nextBtn.currentTitle == "Submit" {
              postData()
        
            return
        }
        
        var q = survey.questions?[questionIndex]
        print(q?.type)
        displayQuestion(q!.type, questionIndex)
        questionIndex += 1
        
    }
    
 
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.minimumValue = Float(survey.questions![questionIndex - 1].content.min!)
        sender.maximumValue = Float(survey.questions![questionIndex - 1].content.max!)
        sliderLabel.text = String(sender.value.rounded())
    }
    
    
    func decodeSurvey(json: JSON){
        
        let color = json["color"].stringValue
        self.view.backgroundColor = UIColor(hexString: color)
        let page = json["pages"][0]["questions"].arrayValue
        print(json["pages"][0])
        for q in page {
            if q["type"].stringValue == "QUESTION_CHECKBOX" || q["type"].stringValue == "QUESTION_SLIDER"  || q["type"].stringValue == "QUESTION_TEXT" {
                let question = Question(q["title"].stringValue, q["type"].stringValue)
                question._id = q["_id"].stringValue
                question.type = q["type"].stringValue
                switch(question.type){
                case "QUESTION_CHECKBOX":
                    question.content.choices = q["content"]["choices"].arrayObject as? [String]
                    break
                case "QUESTION_SLIDER":
                    question.content.min = q["content"]["min"].intValue
                    question.content.max = q["content"]["max"].intValue
                    break
                    
                default :
                    break
                }
                survey.questions?.append(question)
                
            }
            else {continue}
        }
    }
    
    func displayQuestion(_ type: String,_ index: Int){
        if tempView != nil{
            tempView.removeFromSuperview()
        }
        questionLabel.text = survey.questions?[index].title
        
        switch type {
        case "QUESTION_CHECKBOX" :
            choices = []
            tempView = checkView
           checkView.isHidden = false
            setupCheckboxes(index)
            questionView.addSubview(tempView)
            break
        case "QUESTION_SLIDER":
            sliderView.isHidden = false
            tempView = sliderView
            questionView.addSubview(tempView)
            break
        case "QUESTION_TEXT":
        
            textView.isHidden = false
            tempView = textView
            questionView.addSubview(tempView)
            break
        default:
            break
        }
    }
    func setupCheckboxes(_ index: Int){
        let isValid0 = survey.questions![index].content.choices!.indices.contains(0)
        if isValid0{
             checkLabel1.text = survey.questions?[index].content.choices?[0]
        }
        let isValid1 = survey.questions![index].content.choices!.indices.contains(1)
        if isValid1{
            checkLabel2.text = survey.questions?[index].content.choices?[1]
        }
        let isValid2 = survey.questions![index].content.choices!.indices.contains(2)
        if isValid2{
            checkLabel3.text = survey.questions?[index].content.choices?[2]
        }
      
    }
    
    @IBAction func checkBtn1Click(_ sender: Any) {
      
        
        if check1Btn.currentImage == UIImage(named: "Unchecked"){
            check1Btn.setImage(UIImage(named: "Checked"), for: .normal)
        }
        else {
            check1Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
        addCheckboxAnswer(text: checkLabel1.text!)
        
        
    }
    
    @IBAction func checkBtn2Click(_ sender: Any) {
        
        if check2Btn.currentImage == UIImage(named: "Unchecked"){
            check2Btn.setImage(UIImage(named: "Checked"), for: .normal)
        }
        else {
            check2Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
             addCheckboxAnswer(text: checkLabel2.text!)
        
    }
    
    @IBAction func checkBtn3Click(_ sender: Any) {
        
        if check3Btn.currentImage == UIImage(named: "Unchecked"){
            check3Btn.setImage(UIImage(named: "Checked"), for: .normal)
        }
        else {
            check3Btn.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
             addCheckboxAnswer(text: checkLabel3.text!)
    }
    func addCheckboxAnswer(text: String){
        var content = Content()
        choices.append(text)
        content.choices = choices
        let qid = survey.questions?[questionIndex - 1 ]._id
        let answer = Answer(qId: qid!, type: "ANSWER_MULTIPLE_CHOICE", content: content)
        let isValidIndex = fill.answers.indices.contains(questionIndex - 1)
        if isValidIndex {
            fill.answers[questionIndex - 1].content = content
        }else {
            fill.answers.append(answer)
        }
       //print(fill.answers[questionIndex - 1].content.choices!)
    }
    
    
    @objc func viewTapped(){
        textArea.endEditing(true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
extension FillViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        var content = Content()
        content.value = textArea.text!
        guard let id = survey.questions?[questionIndex - 1]._id else { return  }
        let answer = Answer(qId: id, type: "ANSWER_TEXT", content: content)
        fill.answers.append(answer)
    }
}

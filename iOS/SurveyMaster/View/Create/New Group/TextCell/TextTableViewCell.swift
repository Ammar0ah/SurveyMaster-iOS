//
//  TextTableViewCell.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet var QuestionTypeLabel: UILabel!
    @IBOutlet var questionTitleTxt: UITextField!
    var question : Question = Question("Short text","QUESTION_TEXT")
    var returnValue : ((_ value: Question) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        questionTitleTxt.delegate = self
        // Initialization code
    }

    @IBAction func txtChanged(_ sender: Any) {
        question.title = questionTitleTxt.text ?? ""
         returnValue?(question)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        if let active = question.isActive {
//            if !active{
//               self.questionTitleTxt.text! = ""
//            }
//        }
//
//    }
}
extension TextTableViewCell : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        returnValue?(question)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
         textField.resignFirstResponder()
        return false
    }
}

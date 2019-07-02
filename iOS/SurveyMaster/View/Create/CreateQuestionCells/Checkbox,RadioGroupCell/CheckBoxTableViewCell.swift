//
//  CheckBoxTableViewCell.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/1/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
protocol CellDelegate {
    func contentDidChange(cell: UITableViewCell)
}
class CheckBoxTableViewCell: UITableViewCell {
    var check:SliderQuestion = SliderQuestion("","")
    var imageType : String?

    var returnValue: ((_ value:SliderQuestion) -> ())?
    
    
    @IBOutlet var images: UIImageView!
    @IBOutlet var images1: UIImageView!
    @IBOutlet var images2: UIImageView!
    @IBOutlet var choice1: UITextField!
    @IBOutlet var choice2: UITextField!
    @IBOutlet var choice3: UITextField!
    
    @IBOutlet var QuestionTitleText: UITextField!
    
    @IBOutlet var QTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choice1.delegate = self
        choice2.delegate = self
        choice3.delegate = self
        check.content = Content(choices:[])
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
extension CheckBoxTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        check.title = textField.text!;
        check.content.choices?.append(textField.text ?? "No text")
        returnValue?(check)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}

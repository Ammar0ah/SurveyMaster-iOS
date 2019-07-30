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
        QuestionTitleText.delegate = self
        check.content = Content(choices:[])
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func txtChanged(_ sender: UITextField) {
//        if check.content.choices!.count > 0 {
//
//
//        if sender.tag == 0 {
//        check.content.choices?[0] = choice1.text!
//        }
//        if sender.tag == 1 {
//            check.content.choices?[1] = choice2.text!
//        }
//        if sender.tag == 2 {
//            check.content.choices?[2] =
//            choice3.text!
//        }
//             }
        check.content.choices?.append(sender.text!)
    }
    
}
extension CheckBoxTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        check.title = textField.text!;

        returnValue?(check)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}

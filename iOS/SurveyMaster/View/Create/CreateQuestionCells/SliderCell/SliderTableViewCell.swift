//
//  SliderTableViewCell.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    
    @IBOutlet var toggle: UISwitch!
    var slider : SliderQuestion = SliderQuestion("title", "slider")
    var returnValue :((_ value: SliderQuestion)->())?
   @IBOutlet  var maxTxt: UITextField!
    @IBOutlet var minTxt: UITextField!
    @IBOutlet var minLabelTxt: UITextField!
    @IBOutlet var maxLabelTxt: UITextField!
    @IBOutlet var stepTxt: UITextField!
    @IBOutlet var defaultValTxt: UITextField!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        minLabelTxt.delegate = self
        maxLabelTxt.delegate = self
        stepTxt.delegate = self
        maxTxt.delegate = self
        minTxt.delegate = self
        defaultValTxt.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func txtChanged(_ sender: UITextField) {
        switch(sender.tag){
        case 0 :
            slider.content.min = Int(maxTxt.text!) ?? 0
            break
        case 1 :
            slider.content.max = Int(minTxt.text!) ?? 10
            break
        case 2 :
            slider.content.minLabel = minLabelTxt.text!
           
            break
        case 3 :
            slider.content.maxLabel = maxLabelTxt.text!
            break
        case 4 :
             slider.content.step = Int(stepTxt.text!) ?? 1
            break
        case 5:
            slider.content.defaultValue = Int(defaultValTxt.text!) ?? 5
            break
        default: return
        }
    }
}

extension SliderTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        returnValue?(slider)
         //print( slider.content.minLabel)
    }

}

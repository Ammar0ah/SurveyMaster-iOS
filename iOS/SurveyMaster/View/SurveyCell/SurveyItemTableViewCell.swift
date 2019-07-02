//
//  SurvyeTableViewCell.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/4/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class SurveyItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
  

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var deleteImg: UIImageView!
    @IBOutlet var ContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        ContentView.layer.cornerRadius = 10
        colorView.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

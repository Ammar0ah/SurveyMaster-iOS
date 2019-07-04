//
//  BarChartTableViewCell.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/4/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Charts
class BarChartTableViewCell: UITableViewCell {

    @IBOutlet var barChartView: BarChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

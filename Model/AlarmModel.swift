//
//  AlarmModel.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class AlarmModel: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

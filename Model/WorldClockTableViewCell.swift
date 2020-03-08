//
//  WorldClockTableViewCell.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/26/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {

    @IBOutlet weak var timeZoneName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Update time with Timer
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    @objc func setTime() {
        timeLabel.text = getTime()
    }
    
    func getTime() -> String {
        var timeString = ""
        if timeZoneName.text != "" {
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            formatter.timeZone = TimeZone(identifier: timeZoneName.text!)
            
            let timeNow = Date()
            timeString = formatter.string(from: timeNow)
        }
        return timeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  TimerViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Tan on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var milisecondLbl: UILabel!
    
    var minute = 0
    var second = 0
    var milisecond = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func startBtn(_ sender: UIButton) {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        timer.invalidate()
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        timer.invalidate()
        milisecond = 0
        second = 0
        minute = 0
        showTextCurrentTimer()
    }
    
    @objc func updateTime() {
        //Check limitness of milisecond
        if (milisecond + 1 < 10) {
            milisecond += 1
        }
        else {
            second += 1
            milisecond = 0
        }
        
        //Check limitness of second
        if (second + 1 >= 60) {
            second = 0
            minute += 1
        }
        
        if (minute + 1 >= 100){
            minute = 0
            second = 0
            milisecond = 0
        }
        
        showTextCurrentTimer()
        
    }
    
    func showTextCurrentTimer() {
        minuteLbl.text = (minute < 10) ? ("0" + String(minute)) : String(minute)
        secondLbl.text = (second < 10) ? ("0" + String(second)) : String(second)
        milisecondLbl.text = (milisecond < 10) ? ("0" + String(milisecond)) : String(milisecond)
    }
}

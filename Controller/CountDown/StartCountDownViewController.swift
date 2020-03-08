//
//  StartCountDownViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Tan on 5/28/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import AVFoundation

class StartCountDownViewController: UIViewController {
    @IBOutlet weak var hourCount: UILabel!
    @IBOutlet weak var minuteCount: UILabel!
    @IBOutlet weak var secondCount: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var hour:String?
    var minute:String?
    var second:String?
    var secondInt = 0
    var minuteInt = 0
    var hourInt = 0
    var audioPlayer = AVAudioPlayer()
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coverTimeToRightForm()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StartCountDownViewController.updateTime), userInfo: nil, repeats: true)

        do
        {
            let pathAudio = Bundle.main.path(forResource: "countDownRing", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: pathAudio!))
        }
        catch{
            //error
        }
    }


    @IBAction func PauseBtn(_ sender: UIButton) {

        if pauseBtn.titleLabel?.text == "Pause" {
            //Tam dung thoi gian countdown
            timer.invalidate()
            audioPlayer.stop()
            pauseBtn.setTitle("Start", for: .normal)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StartCountDownViewController.updateTime), userInfo: nil, repeats: true)
            pauseBtn.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func ResetBtn(_ sender: UIButton) {
        if(pauseBtn.titleLabel?.text == "Start") {
            pauseBtn.setTitle("Pause", for: .normal)
        }
        timer.invalidate()
        coverTimeToRightForm()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StartCountDownViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    //Ham chuyen cac don vi giay, phut, gio ve moc thoi gian dung
    func coverTimeToRightForm() {
        secondInt = Int(second!)! % 60
        minuteInt = Int(minute!)! + Int(second!)! / 60
        hourInt = Int(hour!)! + minuteInt / 60
        
        //Hien thi gia tri cua gio, phut, giay hien tai
        hourCount.text = String(hourInt)
        minuteCount.text = String(minuteInt)
        secondCount.text = String(secondInt)
    }
    
    //Thuc thi countdown time
    @objc func updateTime() {
        if (secondInt != 0) {
            secondInt -= 1
        }
        else if (secondInt == 0 && minuteInt > 0)   //Khi so giay ve 0 thi so phut giam va so giay reset lai
        {
            secondInt = 59
            minuteInt -= 1
        }
        else if (secondInt == 0 && minuteInt == 0 && hourInt == 0 ) //Khi tat ca cac don vi thoi gian ve 0
        {
            print("Got here")
            secondInt = 0
            timer.invalidate()
            audioPlayer.play()
            createAlert(title: "Count down timer", message: "Count down timer finish. Press OK to turn off alarm")
        }
        else    //Khi so phut va so giay bang 0 nhung so gio van lon hon 0
        {
            hourInt -= 1
            minuteInt = 60
        }
        
        //Hien thi gia tri cua gio, phut, giay hien tai
        secondCount.text = String(secondInt)
        minuteCount.text = String(minuteInt)
        hourCount.text = String(hourInt)
    }
    
    //Alert when alarm is on
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in self.audioPlayer.stop()}))
        self.present(alert, animated: true, completion: nil)
        
    }
}

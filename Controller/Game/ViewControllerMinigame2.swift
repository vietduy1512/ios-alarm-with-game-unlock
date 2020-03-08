//
//  ViewControllerMinigame2.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by AnhLe on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class ViewControllerMinigame2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EditButton()
        random()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var Button: [UIButton]!
    var array: [Int] = []
    var temp = 0
    @IBAction func AcButton(_ sender: UIButton) {
        sender.alpha = 0
        if (temp < array.count){
            if (sender.titleLabel?.text == String(array[temp])){
                temp = temp + 1
                if (temp == array.count) {
                    // ----- Successful -> Stop playing Alarm
                    Scheduler.stopAction()
                    
                }
            }else {
                temp = 0
                
                let alertView = UIAlertController(title: "Failed", message: "Game reset", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
                
                viewDidLoad()
            }
            
        }else {
            
        }
    }
    func EditButton(){
        for button in Button {
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }
    }
    func random(){
        for button in Button {
            button.alpha = 0
        }
        let so = arc4random_uniform(18) + 1
        let arrayButton = generateRandomNumber(0, 17, Int(so))
        var arrayrandom = generateRandomNumber(0, 100, Int(so))
        var temp = 0;
        for i in arrayButton {
            Button[i].alpha = 1
            Button[i].titleLabel?.text = String (arrayrandom[temp])
            Button[i].setTitle(Button[i].titleLabel?.text, for: .normal)
            temp = temp + 1
        }
        array = arrayrandom.sorted()
    }
    func generateRandomNumber(_ from:Int, _ to:Int, _ qut:Int?) -> [Int] {
        var myRandomNumber = [Int]()
        var numberOfNumbers = qut
        let lower = UInt32(from)
        let higher = UInt32(to + 1)
        if numberOfNumbers == nil || numberOfNumbers! > (to - from) + 1 {
            numberOfNumbers = (to - from) + 1
        }
        while myRandomNumber.count != numberOfNumbers {
            let myNumber = arc4random_uniform(higher - lower) + lower
            if !myRandomNumber.contains(Int(myNumber))
            {
                myRandomNumber.append(Int(myNumber))
            }
        }
        return myRandomNumber
    }

}

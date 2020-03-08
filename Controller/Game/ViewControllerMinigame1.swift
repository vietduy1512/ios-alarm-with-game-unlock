//
//  ViewControllerMinigame1.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by AnhLe on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class ViewControllerMinigame1: UIViewController {

    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Text: UITextField!
    @IBOutlet weak var Digital: UILabel!
    var main = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button.layer.borderColor = UIColor.blue.cgColor
        Button.layer.borderWidth = 2
        Button.layer.cornerRadius = 5
        randomDigital()
        // Do any additional setup after loading the view.
    }
    @IBAction func OK(_ sender: Any) {
        if (Text.text != main){
            Text.text = ""
            
            let alertView = UIAlertController(title: "Failed", message: "Game reset", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
            
            viewDidLoad()
        }else {
            // ----- Successful -> Stop playing Alarm
            Scheduler.stopAction()
            
        }
    }
    
    func randomDigital(){
        let so  = arc4random_uniform(4) + 3
        var chuoidigital = String()
        for _ in 1...so{
            var temp = 0
            if (chuoidigital.count==0){
                temp = Int(arc4random_uniform(9) + 1)
            }else {
                temp = Int(arc4random_uniform(10))
            }
            chuoidigital = chuoidigital + String (temp)
        }
        Digital.text = chuoidigital
        while (chuoidigital.count > 1){
            var temp2 = 0;
            for i in chuoidigital {
                temp2 = temp2 + Int(String(i))!
            }
            chuoidigital = String (temp2)
        }
        main = chuoidigital
    }
    
}

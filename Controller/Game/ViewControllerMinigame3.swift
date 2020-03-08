//
//  ViewControllerMinigame3.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by AnhLe on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class ViewControllerMinigame3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        random()
        // Do any additional setup after loading the view.
    }
    var main = String()
    @IBOutlet var Button: [UIButton]!
    
    @IBOutlet weak var Text: UITextField!
    @IBAction func AcButton(_ sender: UIButton) {
        if (sender.titleLabel?.text != main){
            
            let alertView = UIAlertController(title: "Failed", message: "Game reset", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
            
            viewDidLoad()
        }
        else {
            // ----- Successful -> Stop playing Alarm
            Scheduler.stopAction()

        }
        
    }
    
    func random(){
        for button in Button {
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
            button.titleLabel?.text = String ( arc4random_uniform(100))
            button.setTitle(button.titleLabel?.text, for: .normal)
        }
        let temp = arc4random_uniform(12)
        main = (Button[Int(temp)].titleLabel?.text)!
        Text.text = "Select number " + main
        Text.isUserInteractionEnabled = false
    }
    
}

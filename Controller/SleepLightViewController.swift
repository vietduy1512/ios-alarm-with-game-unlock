//
//  SleepLightViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Tan on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import Foundation
import UIKit

class SleepLightViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var colorsText: UITextField!
    @IBOutlet weak var lightSwitch: UISwitch!
    
    @IBOutlet weak var darkSwitch: UISwitch!
    
    
    let colors = [(name:"Red", uicolor:UIColor.red), (name:"Green", uicolor:UIColor.green),
               (name:"Blue", uicolor:UIColor.blue), (name:"Yellow", uicolor:UIColor.yellow),
               (name:"Purple", uicolor:UIColor.purple), (name:"Brown", uicolor:UIColor.brown),
               (name:"Orange", uicolor:UIColor.orange)]
    
    var selectedColor:String?
    let colorPicker = UIPickerView()
    var darkOn = Bool()
    var lightOn = Bool()
    var background = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creratePicker()
        createToolbar()
        
        //Light on or off
        var darkDefault = UserDefaults.standard
        darkOn = darkDefault.bool(forKey: "DarkDefault")
        
        var lightDefault = UserDefaults.standard
        lightOn = lightDefault.bool(forKey: "LightDefault")
        
        if (darkOn == true) {
            lightSwitch.isOn = true
            darkSwitch.isOn = false
            DarkTheme()
           
        }
        if (lightOn == true) {
            darkSwitch.isOn = true
            lightSwitch.isOn = false
            LightTheme()
        }
        
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colors[row].name
        //colorsText.text = colors[row]
        colorsText.text = selectedColor
        self.view.backgroundColor = colors[row].uicolor
        background = colors[row].uicolor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row].name
    }
    
    func creratePicker() {
        colorPicker.delegate = self
        colorsText.inputView = colorPicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SleepLightViewController.dismissKeyboard))
        
        toolbar.setItems([doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        colorsText.inputAccessoryView = toolbar
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func brightnessSlider(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    @IBAction func LightAction(_ sender: Any) {
        lightSwitch.isOn = true
        darkSwitch.isOn = false
        
        LightTheme()
        
        var darkDefault = UserDefaults.standard
        darkDefault.set(true, forKey: "DarkDefault")
        
        
        var lightDefault = UserDefaults.standard
        lightDefault.set(false, forKey: "LightDefault")
    }
    
    @IBAction func DarkAction(_ sender: Any) {
        darkSwitch.isOn = true
        lightSwitch.isOn = false
        
        DarkTheme()
        
        var darkDefault = UserDefaults.standard
        darkDefault.set(false, forKey: "DarkDefault")
        
        
        var lightDefault = UserDefaults.standard
        lightDefault.set(true, forKey: "LightDefault")
    }
    
    func DarkTheme() {
         self.view.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
    }
    
    func LightTheme() {
         self.view.backgroundColor = background
    }
    
}

//
//  AddAlarmController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import UserNotifications

class AddAlarmViewController: UIViewController, UNUserNotificationCenterDelegate, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    var soundDetailLabel = "bell"
    var gameDetailLabel = "Digital Root"
    
    // --- For edited row
    var isEdited = false
    var alarm: Alarm? = nil
    // ------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (isEdited) {
            initDataIfEditing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Init date if editing
    func initDataIfEditing() {
        //datePicker == timeInitString
        titleTextField.text = alarm?.title
        bodyTextField.text = alarm?.body
    }
    
    
    // Mark : Settings Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: Id.alarmSettingCell)
        
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Id.alarmSettingCell)
        }
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                cell!.textLabel!.text = "Sound"
                cell!.detailTextLabel!.text = soundDetailLabel
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 1 {
                cell!.textLabel!.text = "Game"
                cell!.detailTextLabel!.text = gameDetailLabel
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                performSegue(withIdentifier: Id.soundSettingSId, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 1:
                performSegue(withIdentifier: Id.gameSettingSId, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            default:
                break
            }
        }
    }

    

   // ----- Save Right Bar Button -----
    @IBAction func saveNewAlarm(_ sender: Any) {
        
        // Convert Date to string
        // Get time and date
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timeStr = formatter.string(from: datePicker.date)

        formatter.dateFormat = "dd-MM-yyyy hh-mm-ss a"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let dateStr = formatter.string(from: datePicker.date)
        
        // Get title and body
        let titleStr : String
        let bodyStr : String
        if (titleTextField.text == "") {
            titleStr = "Alarm"
        } else {
            titleStr = titleTextField.text!
        }
        if (bodyTextField.text == "") {
            bodyStr = "Default body"
        } else {
            bodyStr = bodyTextField.text!
        }
        
        // Get sound
        let soundStr = soundDetailLabel

        // Get game StoryBoard
        let gameStr : String
        switch gameDetailLabel {
        case "Digital Root":
            gameStr = Id.gameOneSId
        case "Sort Array":
            gameStr = Id.gameTwoSId
        case "Find The Right Number":
            gameStr = Id.gameThreeSId
        default:
            gameStr = Id.gameOneSId
        }
        
       
        // Update data
        if (isEdited) {
            alarm?.time = timeStr
            alarm?.date = dateStr
            alarm?.sound = soundStr
            alarm?.title = titleStr
            alarm?.body = bodyStr
            alarm?.isToggled = true
            if (CoreDataHandler.saveContext()) {
                print("Update success")
            }
        }
        else {
            // Add data
            if (CoreDataHandler.saveAlarm(time: timeStr, date: dateStr, sound: soundStr, game: gameStr, title: titleStr, body: bodyStr, isToggled: true)) {
                print("Save success")
            }
        }

        // Go back to Table
        navigationController?.popViewController(animated: true)
    }
    
    
    // Mark: Navigation
    
    @IBAction func unwindFromSoundSettingView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! SoundSettingTableViewController
        soundDetailLabel = src.chosenSound
        settingsTableView.reloadData()
    }
    
    @IBAction func unwindFromGameSettingView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! GameSettingTableViewController
        gameDetailLabel = src.chosenGame
        settingsTableView.reloadData()
    }
    
}

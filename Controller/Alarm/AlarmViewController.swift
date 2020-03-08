//
//  AlarmsTableController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // ----- Core Data Fetching -----
    var alarmsArray: [Alarm]? = []  // Get Core data Objects
    var data : [(String,String, Bool)] = []
    
    func loadData () {
        alarmsArray = CoreDataHandler.fetchAlarm()
        data = []
        if (alarmsArray != nil) {
            for alarm in alarmsArray! {
                data += [(alarm.time!, alarm.title!, alarm.isToggled)]
            }
        }
        alarmTableView.reloadData()
    }
    
    // ----- Constructor -----
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        Scheduler.openGameIfIsPlaying()
        Scheduler.reSchedule(alarmsArray)
    }
    
    // ----- Bar Button Items -----
    @IBAction func editAlarm(_ sender: Any) {
        alarmTableView.isEditing = !alarmTableView.isEditing
    }
    
    // -------- Table View Delegates --------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell",
                                                 for: indexPath) as! AlarmModel
        // Set data
        let item = data[indexPath.row]
        cell.timeLabel.text = "\(item.0)"
        cell.titleLabel.text = "\(item.1)"
        cell.onSwitch.isOn = item.2
        
        // Create switch button's event
        cell.onSwitch.accessibilityElements = ["\(item.0)", indexPath.row]
        cell.onSwitch.addTarget(self, action: #selector(AlarmViewController.onSwitchToggled), for: .valueChanged)
        
        return cell
    }
    
    @objc func onSwitchToggled(_ sender: UISwitch) {   // Get switch button's event in custom cell
        let alarm = alarmsArray?[sender.accessibilityElements![1] as! Int]
        
        if (sender.isOn) {
            if (alarm?.isToggled == true) { return }
            alarm?.isToggled = true
            
            if (CoreDataHandler.saveContext()) {
                print("Update success")
                Scheduler.reSchedule(alarmsArray)
            }
        } else {
            if (alarm?.isToggled == false) { return }
            alarm?.isToggled = false
            
            if (CoreDataHandler.saveContext()) {
                print("Update success")
                Scheduler.reSchedule(alarmsArray)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // DidSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addAlarmVC = storyboard?.instantiateViewController(withIdentifier: "AddAlarmViewController") as! AddAlarmViewController
        
        if alarmTableView.isEditing == true {
            addAlarmVC.isEdited = true
            addAlarmVC.alarm = alarmsArray?[indexPath.row]
            
            self.navigationController?.pushViewController(addAlarmVC, animated: true)
        }
    }
    
    // Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //remove object from core data
            if (CoreDataHandler.deleteAlarm(alarm: alarmsArray![indexPath.row])) {
                print("Delete alarm success")
                loadData()
                Scheduler.reSchedule(alarmsArray)
            }
        }
    }
}

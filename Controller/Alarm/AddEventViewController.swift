//
//  AddEventViewController.swift
//  24_AlarmProject_1512004_1512012_1512068

//  Created by Tan on 5/30/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import EventKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var notesText: UITextView!
    
    let pickerStartTime = UIDatePicker()
    let pickerEndTime = UIDatePicker()
    var startTimeIsSet:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.delegate = self
        notesText.delegate = self

        //Round button
        addEventBtn.layer.cornerRadius = 10
        textViewDidEndEditing(notesText)
        textViewDidEndEditing(notesText)
        notesText.textColor = UIColor.lightGray
        createDatePicker(picker: pickerStartTime, time: startTime)
        createDatePicker(picker: pickerEndTime, time: endTime)
    }
    
 
    @IBAction func addEventTapped(_ sender: UIButton) {
        print("Get here")
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil)
            {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                let alarm = EKAlarm(relativeOffset: -60)
                event.title = self.titleText.text
                event.startDate = self.pickerStartTime.date
                event.endDate = self.pickerEndTime.date
                event.notes = self.notesText.text
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.isAllDay = false
                event.alarms = [alarm]  //set alarm for event
                do
                {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("Error: \(error)")
                    let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                print("Error: \(error)")
            }
        }
        createAlert(title: "Adding new event", message: "Event is added successfully");
    }
    
    //When "Done" button of start time of event is pressed
    @objc func startDonePressed() {
        print("Value: \(startTimeIsSet)")
        startTime.text = "\(formatDateTime(picker: pickerStartTime))"
        self.view.endEditing(true)
        startTimeIsSet = true
    }
    
    //When "Done" button of end time of event is pressed
    @objc func endDonePressed() {
        print("Value: \(startTimeIsSet)")
        endTime.text = "\(formatDateTime(picker: pickerEndTime))"
        self.view.endEditing(true)
    }
    
    //Format date time from UIDatePicker
    func formatDateTime(picker:UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: picker.date)
    }
    
    func createDatePicker(picker:UIDatePicker, time:UITextField) {
        //Create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()     //size the toolbar to fit the navigation more snugly
        
        if startTimeIsSet == true {
            pickerEndTime.minimumDate = pickerStartTime.date
        }
        
        //Make button "Done" for toolbar
        let doneBtn:UIBarButtonItem
        if(time == startTime) {
            doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDonePressed))
            
        } else {
            //pickerEndTime.minimumDate = pickerStartTime.date   //endtime must be later than start time
            doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDonePressed))
        }
        
        toolbar.setItems([doneBtn], animated: false)
        time.inputAccessoryView = toolbar
        time.inputView = picker
    }
    
    //*****************************   Hide keyboard   ******************************
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    //Hide keyboard after inputting textField - titleText
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleText.resignFirstResponder()
        return true
    }
    
    //Hide keyboard after inputting textView - notesText
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            notesText.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Alert when event is added
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
        titleText.text = ""
        startTime.text = ""
        endTime.text = ""
        notesText.text = ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
    }
 
}

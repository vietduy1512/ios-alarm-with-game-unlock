//
//  Scheduler.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class Scheduler : NSObject, UNUserNotificationCenterDelegate
{
    static var workItemArray : [DispatchWorkItem] = []
    
    class func reSchedule(_ alarmsArray: [Alarm]?) {
        
        // Remove all Notif Request then add again is faster
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for item in workItemArray {
            item.cancel()
        }
        workItemArray = []
        
        for alarm in alarmsArray! {
            if (alarm.isToggled) {
                
                // Setting up
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy hh-mm-ss a"
                formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                let date = formatter.date(from: alarm.date!)
                
                // Set Notification
                Scheduler.setNotificationWithDate(date!, alarm)
            }
        }
    }
    
    
    class func getTimeInterval(_ trigger: Date, _ current: Date) -> TimeInterval {
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: current)
        var trigerComponents = Calendar.current.dateComponents([.timeZone, .hour, .minute], from: trigger)
        trigerComponents.year = currentComponents.year
        trigerComponents.month = currentComponents.month
        trigerComponents.day = currentComponents.day
        
        var date = Calendar.current.date(from: trigerComponents)
        
        // Check if date if before the current to fix to tomorro
        if (date! < current) {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date!)!
        }
        return date!.timeIntervalSince(current)
    }
    
    class func setNotificationWithDate(_ date: Date, _ alarm: Alarm) {
        
        // Setting up Notification Content
        var dict : Dictionary = Dictionary<AnyHashable, Any>()
        dict["sound"] = alarm.sound!
        dict["game"] = alarm.game!
        
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = alarm.title!
        content.body = alarm.body!
        content.userInfo = dict    // Add Sound Name & Game Name to Content
        content.categoryIdentifier = Id.categoryIdentifier
        content.sound = UNNotificationSound.default()
        
        
        // Setting up Trigger
        var triggerDate = DateComponents()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        triggerDate.hour = components.hour!
        triggerDate.minute = components.minute!
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       
        
        // Scheduling Trigger
        let request = UNNotificationRequest(identifier: "AlarmTriggering", content: content, trigger: trigger)

        // Dispatch Queue
        let item = DispatchWorkItem {
            
            // Turn off toggle item
            alarm.isToggled = false;
            if (CoreDataHandler.saveContext()) {
                print("Update success")
            }
            
            // Add Notification Request
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            _content = content
            playSound(alarm.sound!)
        }
        addDispatchQueue(item, getTimeInterval(date, Date()))
    }
    
    class func setCategorySettings() {
        // Custom Action
        let snoozeAction = UNNotificationAction(identifier: Id.snoozeIdentifier,
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: Id.stopIdentifier, title: "Stop", options: [.destructive])
        let category = UNNotificationCategory(identifier: Id.categoryIdentifier,actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        // Set Notification
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    
    
    static var isPlaying: Bool = false
    static var player: AVAudioPlayer?
    static var _content: UNMutableNotificationContent? = nil
    
    class func playSoundAndNotifAfter10min(_ soundName: String) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Scheduling Trigger
        let request = UNNotificationRequest(identifier: "AlarmTriggering", content: _content!, trigger: trigger)
        
        let temp_content = _content
        
        // Dispatch Queue
        let item = DispatchWorkItem {
            // Add Notification Request
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            _content = temp_content
            playSound(soundName)
        }
        addDispatchQueue(item, 600.0)
    }
    
    
    
    class func playSound(_ soundName: String) {
        // Get Sound with soundName
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
            isPlaying = true;
            
            // Play sound for 60 second, then stop
            
            // Dispatch Queue
            let item = DispatchWorkItem {
                // if after 60 second but user still not stop playing sound -> 10 later will play again
                if (isPlaying) {
                    isPlaying = false;
                    player.stop()
                    playSoundAndNotifAfter10min(soundName)
                }
            }
            addDispatchQueue(item, 55.0)    // 55s so it not collide with other alarm
          
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func stopAction() {
        guard let player = player else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.returnToTabBarViewController()
        isPlaying = false;
        player.stop()
    }
    class func snoozeAction(_ soundName: String) {
        guard let player = player else { return }
        isPlaying = false;
        player.stop()
        playSoundAndNotifAfter10min(soundName)
    }
    
    class func addDispatchQueue(_ item: DispatchWorkItem, _ time: TimeInterval) {
        
        workItemArray += [item];
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: item)
        //item.cancel()
    }
    
    class func setContentFromMutableNotificationContent(_ t_content: UNNotificationContent) {
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = t_content.title
        content.body = t_content.body
        content.threadIdentifier = t_content.threadIdentifier
        content.categoryIdentifier = Id.categoryIdentifier
        content.sound = UNNotificationSound.default()
        
        _content = content
    }
    
    class func openGameIfIsPlaying() {
        if (isPlaying) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openGame("Game1")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Used to open game to stop playing alarm
    func openGame(_ gameStoryBoardId: String) {
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: gameStoryBoardId) as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }
    
    
    func returnToTabBarViewController() {
        
        // Return
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabBarViewController") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
       
        
        // Present Alert
        let alertView = UIAlertController(title: "Success", message: "Alarm has turned off", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(okAction)
        self.window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    
    
    // MARK: UserNotification Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Play sound and show alert to the user
        //Scheduler.stopAction()
        //Scheduler.setContentFromMutableNotificationContent(notification.request.content)
        //Scheduler.playSound(notification.request.content.threadIdentifier)
        completionHandler([.alert,.sound])
    }
    
    
    // called when user interacts with notification (app not running in foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier
        {
        case UNNotificationDismissActionIdentifier:
            openGame(response.notification.request.content.userInfo["game"] as! String)
            
        case UNNotificationDefaultActionIdentifier:
            openGame(response.notification.request.content.userInfo["game"] as! String)
            
        case Id.snoozeIdentifier:
            Scheduler.snoozeAction(response.notification.request.content.userInfo["sound"] as! String)
            
        case Id.stopIdentifier:
            openGame(response.notification.request.content.userInfo["sound"] as! String)
            
        default:
            print("Unknown action")
        }
        
        
        return completionHandler()
    }
    
    
}

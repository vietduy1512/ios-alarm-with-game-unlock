//
//  AlarmModel.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveContext() -> Bool {
        let context = getContext()
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    // Save 1 Oject's Data
    class func saveAlarm(time: String, date: String, sound: String, game: String, title: String, body: String, isToggled: Bool) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(time, forKey: "time")
        manageObject.setValue(date, forKey: "date")
        manageObject.setValue(sound, forKey: "sound")
        manageObject.setValue(game, forKey: "game")
        manageObject.setValue(title, forKey: "title")
        manageObject.setValue(body, forKey: "body")
        manageObject.setValue(isToggled, forKey: "isToggled")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    // Get 1 Oject's Data
    class func fetchAlarm() -> [Alarm]? {
        let context = getContext()
        var alarm:[Alarm]? = nil
        do {
            alarm = try context.fetch(Alarm.fetchRequest())
            return alarm
        } catch {
            return alarm
        }
    }
    
    // Delete 1 Object
    class func deleteAlarm(alarm: Alarm) -> Bool {
        let context = getContext()
        context.delete(alarm)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    // Delete Everything
    class func cleanAlarm() -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Alarm.fetchRequest())
        
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}


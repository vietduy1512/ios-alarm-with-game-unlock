//
//  WorldClockViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Tan on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class WorldClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorldClockProtocol {

    @IBOutlet weak var worldClockTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    var timeZonesToDisplay: [String] = []
    
    // ----- Protocol Method -----
    
    func addTimeZone(timeZone: String) {
        timeZonesToDisplay.append(timeZone)
        worldClockTableView.reloadData()
    }
    
    // ----- Constructor -----
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadData()
    }
    
    // ----- Bar Button Items -----
    @IBAction func edit(_ sender: Any) {
        worldClockTableView.isEditing = !worldClockTableView.isEditing
    }
    
    // -------- Table View Delegates --------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZonesToDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell",
                                                 for: indexPath) as! WorldClockTableViewCell
        // Set data
        cell.timeZoneName.text = timeZonesToDisplay[indexPath.row]
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            timeZonesToDisplay.remove(at: indexPath.row)
            worldClockTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TimeZoneModelViewSegue" {
            
            let destination = segue.destination as! TimeZonesTableViewController
            destination.delegate = self
            
        }
    }
    
}

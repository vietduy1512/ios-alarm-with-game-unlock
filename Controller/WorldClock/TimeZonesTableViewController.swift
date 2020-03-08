//
//  TimeZonesTableViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Duy on 5/26/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

// protocol to pass the WorldClockVC's variable as parameter to get data
protocol WorldClockProtocol {
    func addTimeZone(timeZone: String)
    
}

class TimeZonesTableViewController: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchText: UISearchBar!
    
    var timeZones: [String] = []
    
    var delegate : WorldClockProtocol?
    
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        
        timeZones = NSTimeZone.knownTimeZoneNames
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = timeZones[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTimeZone: String = timeZones[indexPath.row]
        delegate?.addTimeZone(timeZone: selectedTimeZone)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UISearchBar Delegate Method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            
            timeZones = NSTimeZone.knownTimeZoneNames.filter { $0.contains(searchText) }
            
        } else {
            
            timeZones = NSTimeZone.knownTimeZoneNames
            
        }
        tableView.reloadData()
    }
}

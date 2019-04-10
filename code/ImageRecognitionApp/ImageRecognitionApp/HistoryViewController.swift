//
//  HistoryViewController.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 07/04/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController {
    var identifiedObjects: [String]!
    /*
     viewWillAppear:
        This is an internal function. It is called before the view controller's view is about to a views hierarchy
        and before any animations are configured for showing the view.
     Parameters:
        animated:
            if true, the view is added to the window using an animation.
     Returns:
        This function does not return any value
    */
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        identifiedObjects = appDelegate.identifiedObjects
        
        self.tableView.reloadData()
    }
    /*
     viewDidLoad:
        This function contains the code for the event\ts that will occur after the view had been loaded.
     Parameters:
        None
     Returns:
        None
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /*
     didRecieveMemoryWarning:
        This is an internal method and it is never directly called by the application.
        Instead, this method is invoked by the system determines the amount of available memory is low.
        This mnethod can also be ovverriden
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //Method to return the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifiedObjects.count
    }
    
    //Method to put the data into the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath)
        cell.textLabel?.text = identifiedObjects[indexPath.row]
        return cell
    }
}

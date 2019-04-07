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
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        identifiedObjects = appDelegate.identifiedObjects
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    // Configure the cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath)
    cell.textLabel?.text = identifiedObjects[indexPath.row]
    return cell
}
}

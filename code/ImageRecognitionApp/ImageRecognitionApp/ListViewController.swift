//
//  ListViewController.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal and Sohil Kaushal on 07/04/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListViewController: UITableViewController {
    var savedObjects: [String]!
    /*
     viewWillAppear:
         This is an in-built function. It is called before the view controller's view is about to a views hierarchy
         and before any animations are configured for showing the view.
     Parameters:
         animated:
             if true, the view is added to the window using an animation.
     Returns:
        This function does not return any value.
     */
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        savedObjects = appDelegate.savedObjects
        
        self.tableView.reloadData()
    }
    /*
     viewDidLoad:
        This function contains the code for the events that will occur after the view had been loaded.
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
         This is an in-built method and it is never directly called by the application.
         Instead, this method is invoked by the system determines the amount of available memory is low.
         This method can also be ovverriden.
     Parameters:
        None
     Returns:
        None
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    /*
     tableView:
         This is an in-built function. This function tells the data source to return the number of rows
         in a given section table view.
     Parameters:
         tableView:
            The tableView object requesting the information.
         section:
            An index number identifing a section in tableView.
     Returns:
        The number of rows in section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedObjects.count
    }
    
    /*
     tableView:
        Asks the data source for a cell to insert in a particular location of the table view.
     Parameters:
        tableView:
            A table-view object requesting the cell.
        indexPath:
            An index path locating a row in tableView.
    Returns:
        An object inheriting from UITableViewCell that the table view can use for the specified row.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath)
        cell.textLabel?.text = savedObjects[indexPath.row]
        return cell
    }
}

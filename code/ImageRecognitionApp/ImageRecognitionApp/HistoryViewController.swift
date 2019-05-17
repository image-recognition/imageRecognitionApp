//
//  HistoryViewController.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 07/04/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UITableViewController {
    var historyObjects: [NSManagedObject]!
    
    //Using a variable for AppDelegate to use the shared data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /*
     viewWillAppear:
        This is an internal function. It notifies the view controller that its view is about to be added to a view hierarchy.
     Parameters:
        animated:
            If true, the view is being added to the window using an animation.
     Returns:
        This function does not return any value.
     */
    override func viewWillAppear(_ animated: Bool) {
        
        //Dark Mode setting
        let settings = appDelegate.defaults
        if settings.string(forKey: "darkMode") == "true" {
            self.tableView.backgroundColor = UIColor.black
            self.tableView.separatorColor = UIColor.lightGray
        } else {
            self.tableView.backgroundColor = UIColor(hex: 0x809AD6)
            self.tableView.separatorColor = UIColor.black
        }
        
        //Populating the tableView
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HistoryObject")
        
        do {
            appDelegate.historyObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            var logs = appDelegate.defaults.string(forKey: "logs")
            logs = logs ?? "" + "\n- Could not fetch. \(error), \(error.userInfo)"
            appDelegate.defaults.set(logs, forKey: "logs")
            showAlert("Could not fetch. \(error), \(error.userInfo)")
        }
        historyObjects = appDelegate.historyObjects
        self.tableView.reloadData()
    }
    
    /*
     viewDidLoad:
        This function contains the code for the events that will occur after the view had been loaded.
     Parameters:
        None
     Returns:
        This function does not return any value.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
     didRecieveMemoryWarning:
        This is an in-built method and it is never directly called by the application.
        Instead, this method is invoked by the system determines the amount of available memory is low.
        This method can also be ovverriden
     Parameters:
        None
     Returns:
        This function does not return any value.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    /*
     tableView(_:numberOfRowsInSection:):
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
        return historyObjects.count
    }
    
    /*
     tableView(_:cellForRowAt:):
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
        let object = historyObjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath)
        
        if appDelegate.defaults.string(forKey: "darkMode") == "true" {
            cell.backgroundColor = UIColor.black
            cell.contentView.backgroundColor = UIColor.black
            cell.textLabel?.textColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor(hex: 0x809AD6)
            cell.contentView.backgroundColor = UIColor(hex: 0x809AD6)
            cell.textLabel?.textColor = UIColor.black
        }
        
        cell.textLabel?.text = object.value(forKey: "name") as? String
        return cell
    }
    
    /*
     showAlert:
        Used to display errors as alerts.
     Parameters:
        error:
            Error message to be displayed.
     Returns:
        This function does not return any value.
     Example of calling:
        showAlert("error message to be displayed")
     */
    func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     tableView(_:commit:forRowAt:)
        Asks the data source to commit the insertion or deletion of a specified row in the receiver.
     Parameters:
        tableView:
            The table-view object requesting the insertion or deletion.
        editingStyle:
            The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
        indexPath:
            An index path locating the row in tableView.
     Returns:
        This function does not return any value.
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if(editingStyle==UITableViewCellEditingStyle.delete) {
            
            managedContext.delete(appDelegate.historyObjects[indexPath.row])
            self.historyObjects.remove(at: indexPath.row)
            self.appDelegate.historyObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try managedContext.save()
            } catch let error as NSError {
                var logs = appDelegate.defaults.string(forKey: "logs")
                logs = logs ?? "" + "\n- Could not save. \(error), \(error.userInfo)"
                appDelegate.defaults.set(logs, forKey: "logs")
                showAlert("Could not save. \(error), \(error.userInfo)")
            }
        }
        self.tableView.reloadData()
    }
    
    /*
     tableView(_:leadingSwipeActionsConfigurationForRowAt:)
        Returns the swipe actions to display on the leading edge of the row.
     Parameters:
        tableView:
            The table view containing the row.
        indexPath:
            The index path of the row.
     Returns:
        The swipe actions to display next to the leading edge of the row. Return nil if you want the table to display the default set of actions.
     */
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Save the history object in the list
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let cell = tableView.cellForRow(at: indexPath)
            let objectLabel = cell?.textLabel?.text
            var objectName = objectLabel?.components(separatedBy: ",")
            ViewController().save(object: "ListObject", name: "\(objectName![0])")
            success(true)
        })
        closeAction.title = "Add to list"
        closeAction.backgroundColor = UIColor(hex: 0x942192)
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
}

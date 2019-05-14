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
    
    var listObjects: [NSManagedObject]!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListObject")
        
        do {
            appDelegate.listObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        listObjects = appDelegate.listObjects
        
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
         This method can also be ovverriden.
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
        return listObjects.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath)
        let object = listObjects[indexPath.row]
        cell.textLabel?.text = object.value(forKey: "name") as? String
        return cell
    }
    
    /*
     AddItem:
        Add an item to the tableView using the alertViewController.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func AddItem(_ sender: Any) {
        let alert = UIAlertController(title: "New Item",
                                      message: "Add a new item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            if textField.text?.isEmpty ?? true {
                return
            }
            
            ViewController().save(object: "ListObject", name: nameToSave)
            self.listObjects = self.appDelegate.listObjects
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    /*
     showAlert:
        Used to display errors as alerts.
     Parameters:
        error:
            Error message to be displayed.
     Returns:
        This function does not return any value.
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
            
            managedContext.delete(appDelegate.listObjects[indexPath.row])
            self.listObjects.remove(at: indexPath.row)
            self.appDelegate.listObjects.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try managedContext.save()
            } catch let error as NSError {
                showAlert("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
}

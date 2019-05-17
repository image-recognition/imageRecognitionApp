//
//  Logs.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 17/05/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import Foundation
import UIKit

class Logs: UIViewController {
    
    //Using a variable for AppDelegate to use the shared data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var logArea: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
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
        
        //Dark Mode Setting
        if appDelegate.defaults.string(forKey: "darkMode") == "true" {
            self.view.backgroundColor = UIColor.black
            logArea.backgroundColor = UIColor.black
            logLabel.textColor = UIColor.lightGray
            logArea.textColor = UIColor.lightGray
            doneButton.setTitleColor(UIColor.red, for: .normal)
        } else {
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            logArea.backgroundColor = UIColor(hex: 0x809AD6)
            logLabel.textColor = UIColor.black
            logArea.textColor = UIColor.black
            doneButton.setTitleColor(UIColor(hex: 0x942192), for: .normal)
        }
    }
    
    /*
     Dismiss:
        Used to dismiss the viewController.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

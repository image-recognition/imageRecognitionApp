//
//  Settings.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 15/05/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Settings: UIViewController {
    
    //Using a variable for AppDelegate to use the shared data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var selectedFlashMode: UISegmentedControl!
    @IBOutlet weak var darkModeState: UISwitch!
    @IBOutlet weak var imageStabilisationState: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var imageStabilisationLabel: UILabel!
    @IBOutlet weak var flashLabel: UILabel!
    @IBOutlet weak var logButton: UIButton!
    
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
            self.view.backgroundColor = UIColor.black
            selectedFlashMode.tintColor = UIColor.lightGray
        } else {
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            selectedFlashMode.tintColor = UIColor.black
        }
        switch settings.string(forKey: "flash") {
        case "false":
            selectedFlashMode.selectedSegmentIndex = 0
        case "true":
            selectedFlashMode.selectedSegmentIndex = 1
        case "auto":
            selectedFlashMode.selectedSegmentIndex = 2
        default:
            selectedFlashMode.selectedSegmentIndex = 2
        }
        
        switch settings.string(forKey: "imageStablisation") {
        case "true":
            imageStabilisationState.isOn = true
        case "false":
            imageStabilisationState.isOn = false
        default:
            imageStabilisationState.isOn = true
        }
        
        switch settings.string(forKey: "darkMode") {
        case "true":
            darkModeState.isOn = true
            darkModeLabel.textColor = UIColor.lightGray
            imageStabilisationLabel.textColor = UIColor.lightGray
            flashLabel.textColor = UIColor.lightGray
            logButton.setTitleColor(UIColor.red, for: .normal)
            logButton.layer.borderColor = UIColor.red.cgColor
        case "false":
            darkModeState.isOn = false
            darkModeLabel.textColor = UIColor.black
            imageStabilisationLabel.textColor = UIColor.black
            flashLabel.textColor = UIColor.black
            logButton.setTitleColor(UIColor(hex: 0x942192), for: .normal)
            logButton.layer.borderColor = UIColor(hex: 0x942192).cgColor
        default:
            darkModeState.isOn = true
            darkModeLabel.textColor = UIColor.black
            imageStabilisationLabel.textColor = UIColor.black
            flashLabel.textColor = UIColor.black
            logButton.setTitleColor(UIColor(hex: 0x942192), for: .normal)
        }
        
        //Setting the button style for log button
        logButton.backgroundColor = .clear
        logButton.layer.cornerRadius = 5
        logButton.layer.borderWidth = 1
        logButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
    }
    
    /*
     flashMode:
        Used to change the flash mode to either off, on or auto
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func flashMode(_ sender: Any) {
        let settings = appDelegate.defaults
        switch selectedFlashMode.selectedSegmentIndex {
        case 0:
            settings.set("false", forKey: "flash")
        case 1:
            settings.set("true", forKey: "flash")
        case 2:
            settings.set("auto", forKey: "flash")
        default:
            settings.set("auto", forKey: "flash")
        }
    }
    
    /*
     DarkModeOnOff:
        Used to toggle the dark mode on or off.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func DarkModeOnOff(_ sender: Any) {
        let settings = appDelegate.defaults
        if darkModeState.isOn {
            settings.set("true", forKey: "darkMode")
            self.view.backgroundColor = UIColor.black
            selectedFlashMode.tintColor = UIColor.lightGray
            darkModeLabel.textColor = UIColor.lightGray
            imageStabilisationLabel.textColor = UIColor.lightGray
            flashLabel.textColor = UIColor.lightGray
            logButton.setTitleColor(UIColor.red, for: .normal)
            logButton.layer.borderColor = UIColor.red.cgColor
        } else {
            settings.set("false", forKey: "darkMode")
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            selectedFlashMode.tintColor = UIColor.black
            darkModeLabel.textColor = UIColor.black
            imageStabilisationLabel.textColor = UIColor.black
            flashLabel.textColor = UIColor.black
            logButton.setTitleColor(UIColor(hex: 0x942192), for: .normal)
            logButton.layer.borderColor = UIColor(hex: 0x942192).cgColor
        }
    }
    
    /*
     ImageStabilisation:
        Used to toggle the image stabilisation on or off.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func ImageStabilisation(_ sender: Any) {
        let settings = appDelegate.defaults
        if imageStabilisationState.isOn {
            settings.set("true", forKey: "imageStabilisation")
        } else {
            settings.set("false", forKey: "imageStabilisation")
        }
    }
    
}

//Extension of class UIColor to set the color using hex value
extension UIColor {
    convenience init(hex: Int) {
        let colorComponents = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: colorComponents.R, green: colorComponents.G, blue: colorComponents.B, alpha: 1)
    }
}


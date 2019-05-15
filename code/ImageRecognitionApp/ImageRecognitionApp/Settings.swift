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
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = appDelegate.defaults
        
        if settings.string(forKey: "darkMode") == "true" {
            self.view.backgroundColor = UIColor.black
            selectedFlashMode.tintColor = UIColor.white
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
        case "false":
            darkModeState.isOn = false
        default:
            darkModeState.isOn = true
        }
    }
    
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
    
    @IBAction func DarkModeOnOff(_ sender: Any) {
        let settings = appDelegate.defaults
        if darkModeState.isOn {
            settings.set("true", forKey: "darkMode")
            self.view.backgroundColor = UIColor.black
            selectedFlashMode.tintColor = UIColor.white
        } else {
            settings.set("false", forKey: "darkMode")
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            selectedFlashMode.tintColor = UIColor.black
        }
    }
    
    @IBAction func ImageStabilisation(_ sender: Any) {
        let settings = appDelegate.defaults
        if imageStabilisationState.isOn {
            settings.set("true", forKey: "imageStabilisation")
        } else {
            settings.set("false", forKey: "imageStabilisation")
        }
    }
    
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}


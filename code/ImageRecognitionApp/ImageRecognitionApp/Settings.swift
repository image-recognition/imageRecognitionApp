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
    @IBOutlet weak var DarkModeState: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        switch appDelegate.defaults.string(forKey: "flash") {
        case "false":
            selectedFlashMode.selectedSegmentIndex = 0
        case "true":
            selectedFlashMode.selectedSegmentIndex = 1
        case "auto":
            selectedFlashMode.selectedSegmentIndex = 2
        default:
            selectedFlashMode.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func flashMode(_ sender: Any) {
        switch selectedFlashMode.selectedSegmentIndex {
        case 0:
            appDelegate.defaults.set("false", forKey: "flash")
        case 1:
            appDelegate.defaults.set("true", forKey: "flash")
        case 2:
            appDelegate.defaults.set("auto", forKey: "flash")
        default:
            appDelegate.defaults.set("auto", forKey: "flash")
        }
    }
    
    @IBAction func DarkModeOnOff(_ sender: Any) {
        if DarkModeState.isOn {
            self.view.backgroundColor = UIColor.black
        } else {
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            
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


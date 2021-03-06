//
//  ViewController.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 29/03/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    var session: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
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
        
        //Using a variable for AppDelegate to use the shared data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Preloading the table cells for testing
        appDelegate.identifiedObjects.append("Orange")
        appDelegate.identifiedObjects.append("Apple")
        appDelegate.savedObjects.append("Orange")
        appDelegate.savedObjects.append("MacBook Air")
        
        //Activating the camera view
        session = AVCaptureSession()
        session.sessionPreset = .medium
        let backCamera =  AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                cameraView.layer.addSublayer(videoPreviewLayer)
                session!.startRunning()
            }
        }
    }
    
    //Variable for the camera view
    @IBOutlet weak var cameraView: UIView!
    
    /*
     takePicture:
        This function is used to take a picture from the camera view.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        None
     */
    @IBAction func takePicture(_ sender: Any) {
        
    }
    /*
     viewDidAppear:
        This is an internal function. Notifies the view controller that its view was added to a view hierarchy.
     Parameters:
        animated:
            If true, the view was added to the window using an animation.
     Returns:
        This function does not return any value
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Setting the video layer frame to the camera view boundaries
        videoPreviewLayer?.frame = cameraView!.bounds
    }
}

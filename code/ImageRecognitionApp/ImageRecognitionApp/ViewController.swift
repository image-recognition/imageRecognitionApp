//
//  ViewController.swift
//  ImageRecognitionApp
//
//  Created by Shubham Jindal on 29/03/19.
//  Copyright © 2019 sjc. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Vision

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var recognisedObjectLabel: UILabel!
    
    //Using a variable for AppDelegate to use the shared data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if appDelegate.defaults.string(forKey: "darkMode") == "true" {
            return .lightContent
        } else {
            return .default
        }
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
        
        let settings = appDelegate.defaults
        if settings.string(forKey: "flash") == nil {
            settings.set("auto", forKey: "flash")
        }
        
        if settings.string(forKey: "imageStabilisation") == nil {
            settings.set("true", forKey: "imageStabilisation")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = appDelegate.defaults
        let darkMode = settings.string(forKey: "darkMode")
        if darkMode == nil {
            settings.set("false", forKey: "darkMode")
        } else if darkMode == "true" {
            self.view.backgroundColor = UIColor.black
            self.cameraView.backgroundColor = UIColor.black
            self.imageViewContainer.backgroundColor = UIColor.black
            self.capturedImageView.backgroundColor = UIColor.black
            self.captureButton.setTitleColor(UIColor.white, for: .normal)
            self.recognisedObjectLabel.textColor = UIColor.white
        } else if darkMode == "false" {
            self.view.backgroundColor = UIColor(hex: 0x809AD6)
            self.cameraView.backgroundColor = UIColor(hex: 0x809AD6)
            self.imageViewContainer.backgroundColor = UIColor(hex: 0x809AD6)
            self.capturedImageView.backgroundColor = UIColor(hex: 0x809AD6)
            self.captureButton.setTitleColor(UIColor(hex: 0x942192), for: .normal)
            self.recognisedObjectLabel.textColor = UIColor.black
        }
    }
    
    /*
     viewWillDisappear:
        This is an internal function. Notifies the view controller that its view is about to be removed from a view hierarchy.
     Parameters:
        animated:
            If true, the disappearance of the view is being animated.
     Returns:
        This function does not return any value.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    
    /*
     didReceiveMemoryWarning:
        This is an internal function. Sent to the view controller when the app receives a memory warning.
     Parameters:
        None
     Returns:
        This function does not return any value.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
     save:
        This function is used to save mock data into the core data for the history viewController.
     Parameters:
        name:
            A string parameter which is a name of the object to be stored in the history.
     Returns:
        This function does not return any value.
     */
    func save(object: String, name: String) {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: object, in: managedContext)!
        
        let saveObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        saveObject.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            if object == "HistoryObject" {
                appDelegate.historyObjects.append(saveObject)
            }
            else if object == "ListObject" {
                appDelegate.listObjects.append(saveObject)
            }
        } catch let error as NSError {
            showAlert("Could not save object. \(error), \(error.userInfo)")
        }
    }
    
    /*
     photoOutput:
        This is an internal function. Provides the delegate with the captured image and associated metadata resulting from a photo capture.
     Parameters:
        captureOutput:
            The photo output performing the capture.
        photo:
            An object containing the captured image pixel buffer, along with any metadata and attachments captured along with the photo (such as a preview image or depth map).
        error:
            If the capture process could not proceed successfully, an error object describing the failure; otherwise, nil.
     Returns:
        This function does not return any value.
     */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let dataOfImage = photo.fileDataRepresentation()
            else {
                showAlert("Cannot generate photo representation!")
                return
        }
        let image = UIImage(data: dataOfImage)
        capturedImageView.image = image
    }
    
    //Variable for the camera view
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var imageViewContainer: UIView!
    //Variable for the still image view
    @IBOutlet weak var capturedImageView: UIImageView!
    
    //Variable for the label used for the recognised objects
    @IBOutlet weak var recognisedObject: UILabel!
    
    /*
     takePicture:
        This function is used to take a picture from the camera view.
     Parameters:
        sender:
            Since this is an IBAction, the function will be called when the button is clicked.
     Returns:
        This function does not return any value.
     */
    @IBAction func takePicture(_ sender: Any) {
        
        //Settings for camera while taking a picture
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        if appDelegate.defaults.string(forKey: "flash") == "auto" || appDelegate.defaults.string(forKey: "flash") == nil {
            settings.flashMode = .auto
        } else if appDelegate.defaults.string(forKey: "flash") == "true" {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }
        
        if appDelegate.defaults.string(forKey: "imageStabilisation") == "true" || appDelegate.defaults.string(forKey: "imageStabilisation") == nil {
            settings.isAutoStillImageStabilizationEnabled = true
        } else {
            settings.isAutoStillImageStabilizationEnabled = false
        }
        
        
        
        //Setting the orientation of the image
        switch (UIDevice.current.orientation) {
        case .landscapeLeft: stillImageOutput.connection(with: AVMediaType.video)?.videoOrientation = .landscapeRight
            break
        case .portrait: stillImageOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
            break
        case .landscapeRight: stillImageOutput.connection(with: AVMediaType.video)?.videoOrientation = .landscapeLeft
            break
        default: stillImageOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
            break
        }
        
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
        
        //Save the recognised object in history
        self.save(object: "HistoryObject", name: self.recognisedObject.text!)
    }
    
    /*
     updateOrientation:
        Used to update the orientation of the camera according to the device orientation.
     Parameters:
        layer:
            The layer of type AVCaptureVideoPreviewLayer on which the orientation has to be applied.
        orientation:
            The orientation to be set.
     Returns:
        This function does not return any value.
     */
    private func updateOrientation(layer: AVCaptureVideoPreviewLayer, orientation: AVCaptureVideoOrientation) {
        layer.connection?.videoOrientation = orientation
    }
    
    /*
     viewDidLayoutSubviews:
        This is an internal function. Called to notify the view controller that its view has just laid out its subviews.
     Parameters:
        None
     Returns:
        This function does not return any value.
     */
    override func viewDidLayoutSubviews() {
        let deviceOrientation = UIDevice.current.orientation
        
        if (videoPreviewLayer != nil) {
            switch (deviceOrientation) {
            case .landscapeLeft: updateOrientation(layer: videoPreviewLayer!, orientation: .landscapeRight)
                break
            case .portrait: updateOrientation(layer: videoPreviewLayer!, orientation: .portrait)
                break
            case .landscapeRight: updateOrientation(layer: videoPreviewLayer!, orientation: .landscapeLeft)
                break
            default: updateOrientation(layer: videoPreviewLayer!, orientation: .portrait)
                break
            }
        }
    }
    
    /*
     viewDidAppear:
        This is an internal function. Notifies the view controller that its view was added to a view hierarchy.
     Parameters:
        animated:
            If true, the view was added to the window using an animation.
     Returns:
        This function does not return any value.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Activating the camera view
        session = AVCaptureSession()
        session.sessionPreset = .medium
        var error: NSError?

        //Check if the camera is available
        let available = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        do {
            if let captureDevice = available.first {
                session.addInput(try AVCaptureDeviceInput(device: captureDevice))
            }
        } catch let error1 as NSError {
            error = error1
            showAlert(error!.localizedDescription)
        }
        
        let captureOutput = AVCaptureVideoDataOutput()
        
        if error == nil && session!.canAddOutput(captureOutput) {
            session!.addOutput(captureOutput)
            stillImageOutput = AVCapturePhotoOutput()
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                
                //Setting the camera to fill the entire view
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                //Append the camera to the view
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "vidQueue"))
                
                //Start the session
                DispatchQueue.global(qos: .userInitiated).async {
                    self.session!.startRunning()
                }
            }
        }
        
        //Setting the video layer frame to the camera view boundaries
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.cameraView!.bounds
        }
    }
    
    /*
     captureOutput(_:didOutput:from:):
        This is an internal function. Notifies the delegate that a new video frame was written.
     Parameters:
        captureOutput:
            The capture output object.
        sampleBuffer:
            A CMSampleBuffer object containing the video frame data and additional information about the frame, such as its format and presentation time.
        connection:
            The connection from which the video was received.
     Returns:
        This function does not return any value.
     */
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let model = try? VNCoreMLModel(for: object().model) else {  fatalError("Unable to convert to Vision Core ML Model")  }
        
        let request = VNCoreMLRequest(model: model) {   (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {  return  }
            guard let observation = results.first else {  return  }
            
            let predictionClass = "\(observation.identifier)"
            let predictionConfidence = String(format: "%.02f%", observation.confidence * 100)
            
            DispatchQueue.main.async(execute: {
                self.recognisedObject.text = "\(predictionClass) \(predictionConfidence)%"
            })
            
            if error != nil {
                self.showAlert(error as! String)
            }
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {  return  }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

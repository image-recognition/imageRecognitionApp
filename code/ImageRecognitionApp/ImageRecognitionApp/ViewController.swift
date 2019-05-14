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
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //Using a variable for AppDelegate to use the shared data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
            print("Could not save object. \(error), \(error.userInfo)")
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
            else { return }
        let image = UIImage(data: dataOfImage)
        capturedImageView.image = image
    }
    
    //Variable for the camera view
    @IBOutlet weak var cameraView: UIView!
    
    //Variable for the still image view
    @IBOutlet weak var capturedImageView: UIImageView!
    
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
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
        
        self.save(object: "HistoryObject", name: self.recognisedObject.text!)
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

        let available = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        do {
            if let captureDevice = available.first {
                session.addInput(try AVCaptureDeviceInput(device: captureDevice))
            }
        } catch let error1 as NSError {
            error = error1
            print(error!.localizedDescription)
        }
        
        let captureOutput = AVCaptureVideoDataOutput()
        
        if error == nil && session!.canAddOutput(captureOutput) {
            session!.addOutput(captureOutput)
            stillImageOutput = AVCapturePhotoOutput()
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                cameraView.layer.addSublayer(videoPreviewLayer)
                
                captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "vidQueue"))
                
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
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {  return  }
        
        let request = VNCoreMLRequest(model: model) {   (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {  return  }
            guard let observation = results.first else {  return  }
            
            let predictionClass = "\(observation.identifier)"
            let predictionConfidence = String(format: "%.02f%", observation.confidence * 100)
            
            DispatchQueue.main.async(execute: {
                self.recognisedObject.text = "\(predictionClass) \(predictionConfidence)%"
            })
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {  return  }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
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
}

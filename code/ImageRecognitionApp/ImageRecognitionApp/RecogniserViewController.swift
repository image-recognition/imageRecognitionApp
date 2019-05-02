//
//  File.swift
//  ImageRecognitionApp
//
//  Created by Sohil Kaushal on 2/5/19.
//  Copyright © 2019 sjc. All rights reserved.
//
import UIKit
import Vision
import Foundation

class RecogniserViewController : UIViewController {
    let mobileNet = MobileNet()
    let image = UIImage()
    func recogniseImage(image: UIImage) -> String? {
        return nil
    }
    func classifyObject(image: UIImage) {
        guard let vision = try? VNCoreMLModel(for: mobileNet.model)
        else {
            fatalError("Unable to convert the model")
        }
        let classificationRequest = VNCoreMLRequest(model: vision, completionHandler: self.handleClassificationResults)
        guard let newCGImage = image.cgImage else {
            fatalError("Unable to convert \(image) to CGImage.")
        }
        let newCGImagOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        let requestHandler = VNImageRequestHandler(cgImage: newCGImage, orientation: newCGImagOrientation)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([classificationRequest])
            } catch  {
                print("Error while performing classifications")
            }
        }
    }
    func handleClassificationResults(for request: VNRequest, error: Error?){
        guard let classifications = request.results as? [VNClassificationObservation],
            let topClassification  = classifications.first else {
            self.showFailure()
            return
        }
        self.setupPrediction(prediction: topClassification.identifier)
    }
    // TODO
    func showFailure() {
        
    }
    // TODO
    func setupPrediction() {
        
    }
}


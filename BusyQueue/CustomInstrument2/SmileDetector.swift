//
//  SmileDetector.swift
//  CustomInstrument2
//
//  Created by Marin Todorov on 10/27/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SmileDetector: NSObject {
  var callback: ((Bool) -> Void)!
  private var lastValue = false

  private let session = AVCaptureSession()
  private let captureQueue = DispatchQueue(label: "com.timelane.capture", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
  
  convenience init(callback: @escaping (Bool) -> Void) throws {
    self.init()
    self.callback = callback
    
    // Fetch camera
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
      fatalError("Front camera not found")
    }
    
    // Add camera as input
    let cameraInput = try AVCaptureDeviceInput(device: camera)
    session.addInput(cameraInput)
    
    // Capture video input
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

    // Start session
    session.addOutput(videoOutput)
    session.startRunning()
  }
    
    deinit {
        print("Smile detector is gone!")
    }
}

extension SmileDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // 1
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }

    let context = CIContext()
    let ciImage = CIImage(cvPixelBuffer: imageBuffer)

    let orientation: UIImage.Orientation
    switch connection.videoOrientation {
    case .portrait: orientation = .up
    case .landscapeLeft: orientation = .left
    case .landscapeRight: orientation = .right
    case .portraitUpsideDown: orientation = .down
    @unknown default: fatalError()
    }
    
    let uiImage = UIImage(ciImage: ciImage, scale: UIScreen.main.scale, orientation: orientation)
    
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [
                                    CIDetectorAccuracy: CIDetectorAccuracyHigh
                                  ])!
    let faces = faceDetector.features(in: uiImage.ciImage!, options: [CIDetectorEyeBlink: true,
                                                                      CIDetectorSmile: true])
    if let face = faces.first as? CIFaceFeature {
      if face.hasSmile != lastValue {
        lastValue = face.hasSmile
        DispatchQueue.main.async {
            self.callback(self.lastValue)
        }
      }
    }
  }
}

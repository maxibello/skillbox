//
//  CameraController.swift
//  AV Foundation
//
//  Created by Maksim Kuznetsov on 06.11.2021.
//  Copyright © 2021 Pranjal Satija. All rights reserved.
//

import AVFoundation
import UIKit


class CameraController: NSObject {
    
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var videoRecordCompletionBlock: ((URL?, Error?) -> Void)?
    
    var outputType: OutputType?
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices.compactMap { $0 }
             
            //2
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
             
                if camera.position == .back {
                    self.rearCamera = camera
             
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
         
            //4
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
         
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
         
                self.currentCameraPosition = .rear
            }
         
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
         
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
         
                self.currentCameraPosition = .front
            }
         
            else { throw CameraControllerError.noCamerasAvailable }
        }
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
         
            outputType = .photo
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
         
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
         
            captureSession.startRunning()
        }
        
        func configureVideoOutput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }

            self.videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.videoOutput!) {
                captureSession.addOutput(self.videoOutput!)
            }
            
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try configureVideoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
     
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
     
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        print(view.frame)
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func switchCameras() throws {
        
        //5
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
         
        //6
        captureSession.beginConfiguration()
         
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                    let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
             
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
             
                captureSession.removeInput(rearCameraInput)
             
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
             
                    self.currentCameraPosition = .front
                }
             
                else { throw CameraControllerError.invalidOperation }
        }
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                    let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
             
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
             
                captureSession.removeInput(frontCameraInput)
             
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
             
                    self.currentCameraPosition = .rear
                }
             
                else { throw CameraControllerError.invalidOperation }
        }
         
        //7
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
         
        case .rear:
            try switchToFrontCamera()
        }
         
        //8
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
         
            let settings = AVCapturePhotoSettings()
            settings.flashMode = self.flashMode
         
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
            self.photoCaptureCompletionBlock = completion
    }
    
    func recordVideo(completion: @escaping (URL?, Error?)-> Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput!.startRecording(to: fileUrl, recordingDelegate: self)
        self.videoRecordCompletionBlock = completion
    }
    
    func stopRecording(completion: @escaping (Error?)->Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(CameraControllerError.captureSessionIsMissing)
            return
        }
        self.videoOutput?.stopRecording()
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
    }

}

extension CameraController {
    enum CameraControllerError: Swift.Error {
            case captureSessionAlreadyRunning
            case captureSessionIsMissing
            case inputsAreInvalid
            case invalidOperation
            case noCamerasAvailable
            case unknown
    }

    public enum CameraPosition {
        case front
        case rear
    }
    
    public enum OutputType {
            case photo
            case video
        }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            self.videoRecordCompletionBlock?(outputFileURL, nil)
        } else {
            self.videoRecordCompletionBlock?(nil, error)
        }
    }
}

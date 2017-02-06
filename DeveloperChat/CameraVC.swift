//
//  ViewController.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/4/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class CamaraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

   
    @IBOutlet weak var previewView: AAPLPreviewView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        delegate = self
        
        _previewView = previewView
        super.viewDidLoad()
    
    }

    @IBAction func changeCameraBtnPressed(_ sender: Any) {
        changeCamera()
    }
    
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        toggleMovieRecording()
    }
    
    func shouldEnableCameraUI(_ enable: Bool) {
        cameraBtn.isEnabled = enable
        print("Should enable camera UI: \(enable)")
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        recordBtn.isEnabled = enable
        print("Should enable record UI: \(enable)")
    }
    
    func recordingHasStarted() {
        print("Recording has started")
    }
    
    func canStartRecording() {
        print("Can start recording")
    }
}


//
//  ViewController.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/4/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class CamaraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

   
    @IBOutlet weak var previewView: AAPLPreviewView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        delegate = self
        
        _previewView = previewView
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
          isUserLoggedIn()
    }

    @IBAction func changeCameraBtnPressed(_ sender: Any) {
        changeCamera()
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        toggleMovieRecording()
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        AuthService.instance.logout()
        isUserLoggedIn()
    }
    
    func isUserLoggedIn() {
        guard FIRAuth.auth()?.currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            print("MOR: User was not logged in. Displaying login screen")
            return
        }
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
    
    func videoRecordingFailed() {
        print("Video Recording Failed")
    }
    
    func videoRecordingComplete(_ videoURL: URL!) {
        performSegue(withIdentifier: "UsersVC", sender: ["videoURL":videoURL])
    }
    
    func snapshotFailed() {
        print("Snapshot Failed")
    }
    
    
    func snapshotTaken(_ snapshotData: Data!) {
        performSegue(withIdentifier: "UsersVC", sender: [snapshotData: snapshotData])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let usersVC = segue.destination as? UsersVC {
            if let videoDict = sender as? Dictionary<String, URL> {
                let url = videoDict["videoURL"]
                usersVC.videoURL = url
            } else if let snapDict = sender as? Dictionary<String, Data> {
                let snapData = snapDict["snapshotData"]
                usersVC.snapData = snapData
            }
        }
    }
    
}


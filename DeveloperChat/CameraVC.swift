//
//  ViewController.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/4/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class CamaraVC: AAPLCameraViewController {

   
    @IBOutlet weak var previewView: AAPLPreviewView!
    
    override func viewDidLoad() {
        self._previewView = previewView
        super.viewDidLoad()
    
    }

    

}


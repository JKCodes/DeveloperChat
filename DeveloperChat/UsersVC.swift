//
//  UsersVC.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/6/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        get {
          return _snapData
        } set {
            _snapData = newValue
        }
    }
    
    var videoURL: URL? {
        get {
            return _videoURL
        } set {
            _videoURL = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPRBtnPressed(_ sender: Any) {
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            let _ = ref.putFile(url, metadata: nil, completion: { (meta: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    print("MOR: Error uploading video: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    
                    // This currently sends to all users in database...
                    DataService.instance.sendMediaPullRequest(senderUID: (FIRAuth.auth()?.currentUser?.uid)!, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnippet: "Coding today was LEGIT!")
                    print("Download URL: \(downloadURL)")
                    // Save this somewhere
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let snapName = "\(NSUUID().uuidString).jpg"
            let ref = DataService.instance.imagesStorageRef.child(snapName)
            
            let _ = ref.put(snap, metadata: nil, completion: { (meta: FIRStorageMetadata?,err: Error?) in
                
                if err != nil {
                    print("MOR: Error uploading snap: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    print("MOR: Download URL: \(downloadURL)")
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
}

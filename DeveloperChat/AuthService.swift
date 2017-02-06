//
//  AuthService.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/6/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            print("MOR: User has been logged out successfully")
        } catch {
            print("MOR: An Error occurred while signing out the user")
        }
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil  {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                // Account already exists
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    
                                    // Save user when it is created
                                    DataService.instance.saveUser(uid: user!.uid)
                                    // Sign in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        // Signin Failure
                                        if error != nil {
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                        } else {
                                            // Login successful - new account created
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // Handle all other errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                }
            } else {
                // Successfully Logged in - without creating an account
                onComplete?(nil, user)
                print("MOR: User was logged in successfully")
                
            }
        })
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch(errorCode) {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid Email Address", nil)
                break
            case .errorCodeWrongPassword:
                onComplete?("Invalid Password", nil)
                break
            case .errorCodeWeakPassword:
                onComplete?("Password must be at least 6 characters", nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    
}

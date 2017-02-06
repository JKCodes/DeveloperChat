//
//  User.swift
//  DeveloperChat
//
//  Created by Joseph Kim on 2/6/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
}

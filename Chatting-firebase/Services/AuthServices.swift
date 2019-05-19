//
//  AuthServices.swift
//  Chatting-firebase
//
//  Created by apple on 4/21/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import Foundation
import Firebase

class AuthServices {
    static let instance = AuthServices()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false,error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email] // providers like facebook, gmail, email
             DataServices.instance.createDBUsers(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    // error is optional because not always have a error
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                    loginComplete(false, error)
                    return
                }

            loginComplete(true, nil)
        }
    }
}

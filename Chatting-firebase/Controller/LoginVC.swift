//
//  LoginVC.swift
//  Chatting-firebase
//
//  Created by apple on 4/21/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self

    }
    @IBAction func signinBtnPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthServices.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print(String(describing: loginError?.localizedDescription))
                }
                AuthServices.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registerationError) in
                    if success {
                        AuthServices.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            print("Succesfly Register user")
                           // self.dismiss(animated: true, completion: nil)
                        })
                    }else {
                        print(String(describing: registerationError?.localizedDescription))
                    }
                })
            }
        }
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {}

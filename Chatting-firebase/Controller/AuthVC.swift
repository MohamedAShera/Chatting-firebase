//
//  AuthVC.swift
//  Chatting-firebase
//
//  Created by apple on 4/21/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func siginWithEmailBtnPressed(_ sender: Any) {
        // when email BTn Was pressed GO TO LoginVC
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    @IBAction func googleSigninBtnPressed(_ sender: Any) {
    }
    @IBAction func facebookSigninBtnPressed(_ sender: Any) {
    }
}

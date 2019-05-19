//
//  CreateGroupsVC.swift
//  Chatting-firebase
//
//  Created by apple on 4/22/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var tilteTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    // create an array to hold people you selected to add in array
    var choosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self
        // to observe every letter you added   .editingChanged ---> to montioring what is happening in textField
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    // to hide done button until you selected users
    override func viewWillAppear(_ animated: Bool) {
        doneBtn.isHidden = true
    }
    // func that call every editing
    @objc func textFieldDidChange() {
        // when we typingText it should searching
        // if we delete any thing it should clear the array
        if emailSearchTextField.text == "" {
            emailArray = []
            tableView.reloadData()
            doneBtn.isHidden = true
           // debugPrint(emailArray)
        }else {
            DataServices.instance.getEmail(forSearchQuary: emailSearchTextField.text!) { (returnEmailArray) in
                self.emailArray = returnEmailArray
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        if tilteTextField.text != "" && descriptionTextField.text != "" {
            // to get the user id by email
            DataServices.instance.getIds(forUserName: choosenUserArray) { (idsArray) in
                // we want add my self to this idsArray
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataServices.instance.createGroup(withTitle: self.tilteTextField.text!, AndDescription: self.descriptionTextField.text!, forUsersIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        print("Group not be created. Please try agin")
                    }
                })
            }
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        if choosenUserArray.contains(emailArray[indexPath.row]) {
             cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true) // to get email from search
        }else {
             cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false) // to get email from search
        }
        return cell
    }
    // to know if user select this row or not
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !choosenUserArray.contains(cell.emailLbl.text!) {
            choosenUserArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = choosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        }else {
            choosenUserArray = choosenUserArray.filter({ $0 != cell.emailLbl.text }) // return every body in array excpet the person who did select
            // if i select one and i remove it again the emailLbl.text! will be contain empty string becasue the array is empty
            if choosenUserArray.count >= 1 {
                 groupMemberLbl.text = choosenUserArray.joined(separator: ", ")
            }else {
                groupMemberLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
    
    
}
// to monitor what's gonna on when typing in textField
// to able search letter by letter
extension CreateGroupsVC: UITextFieldDelegate {
    
}

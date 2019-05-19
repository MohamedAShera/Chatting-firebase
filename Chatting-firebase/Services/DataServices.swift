//
//  DataServices.swift
//  Chatting-firebase
//
//  Created by apple on 4/21/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import Foundation
import Firebase
// make the variable to can access Database
let DB_BASE = Database.database().reference()

class DataServices {
    static let instance = DataServices()
    // Hold the value of DB_BASE
    private var _REF_BASE = DB_BASE
    //Hold  ulr for users information
    private var _REF_USERS = DB_BASE.child("users")  // create a foldare to hold the users
    //Hold refrence of users Group information
    private var _REF_GROUPS = DB_BASE.child("groups") // create a foldare to hold the child
    //Hold refrence of Feed information
    private var _REF_FEED = DB_BASE.child("feed")
    
    // public variable to access the private var
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    // create a funcation to create a firebase user and  push information to the firebase
    //uid is unique id for each user
    //userData: is the data of user like email and emailType
    func createDBUsers(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData) // to access the user updateChildValues means inside the user we pass the data dictionary
    }
    // create a func to upload post
    func uoloadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            // send to group refrence
        }else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid]) // to auto generate ID for each message
            sendComplete(true)
        }
    }
    // to download all of message from firebase and pass it to messageArray to can read it 
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    // func to convert id into username
    func getUserName(forUID uid: String, handler: @escaping (_ userName: String) -> ()) {
        // we need to get unique id and search in all users and find which user have this id and present this user name
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in usersSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        } // .value mean all value in the users
    }
    // to get the email by search
    func getEmail(forSearchQuary query:  String, handler: @escaping  (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                // to get the email of user you search about it and put it in a constant
                let email = user.childSnapshot(forPath: "email").value as! String // now we have an email of the users
                // now we gonna check if the letter that enter by serach that equal an email and get all email contain that letter
                if email.contains(query) == true && email != Auth.auth().currentUser?.email { // query mean the letter you searched by it
                    emailArray.append(email)
                    // i should't to be able to add my self into group i should atuomaticly enter to the group
                    
                }
                
            }
            handler(emailArray)
        }
    }
    // funcation you pass an array of email and return ids of it user
    func getIds(forUserName usersName: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            var idArray = [String]()
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapShot {
                 let email = user.childSnapshot(forPath: "email").value as! String
                if usersName.contains(email) {
                    idArray.append(user.key) // this to add a id from email
                }
            }
            handler(idArray) // to return array of ids
        }
    }
    // create a funcation to create a group
    func createGroup(withTitle title: String, AndDescription description: String, forUsersIds id: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": id])
        handler(true)
    }
}

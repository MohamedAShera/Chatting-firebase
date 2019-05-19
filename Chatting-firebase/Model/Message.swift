//
//  Message.swift
//  Chatting-firebase
//
//  Created by apple on 4/22/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit

class Message {
    private var _content: String
    private var _senderId: String
    
    var content: String {
        return _content
    }
    var senderId: String {
        return _senderId
    }
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
}

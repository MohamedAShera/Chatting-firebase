//
//  UserCell.swift
//  Chatting-firebase
//
//  Created by apple on 4/22/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    // make a variable to can select and can deselect item (flip flop)
    var showing = false
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
            checkImage.isHidden = false
                showing = true
            }else {
                checkImage.isHidden = true
                showing = false
            }
        }
        // Configure the view for the selected state
    }
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.emailLbl.text = email
        if isSelected {
            self.checkImage.isHidden = false
        }else {
            self.checkImage.isHidden = true
        }
    }

}

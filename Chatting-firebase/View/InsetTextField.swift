//
//  InsetTextField.swift
//  Chatting-firebase
//
//  Created by apple on 4/21/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
// we want to set a costum placeholder
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    override func awakeFromNib() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.attributedPlaceholder = placeholder
        super.awakeFromNib()
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

//
//  CustomTextField.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 19/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        
        let spaceLabel1 = UILabel()
        spaceLabel1.frame = CGRect(x: 10, y: 0, width: 7, height: 26)
        spaceLabel1.backgroundColor = UIColor.clear
        
        self.textColor = UIColor.gray
        self.font = UIFont(name: "Lato", size: 20)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        self.leftView = spaceLabel1
        self.leftViewMode = UITextField.ViewMode.always
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
    }

}

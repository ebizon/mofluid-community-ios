//
//  CustomButton.swift
//  Mofluid
//
//  Created by Sadique_ebizon on 19/01/16.
//  Copyright © 2016 Mofluid. All rights reserved.
//

import UIKit

// Custome class for button 

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        
        self.backgroundColor = Settings().getButtonBgColor()//UIColor(red: (223/255.0), green: (114/255.0), blue: (114/255.0), alpha: 1.0)
        self.layer.cornerRadius = 3.0
        self.titleLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.Center
    }
}

//
//  CheckBoxButton.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class CheckBoxButton : FlipFlopButton{
    
    fileprivate let selectCheckboxImage = UIImage(named: "check-active")
    fileprivate let unselectCheckboxImage = UIImage(named: "check-normal")
    
    init(){
        super.init(frame : CGRect.zero)
        
        self.selectedImage = selectCheckboxImage
        self.unselectedImage = unselectCheckboxImage
        
        self.isSelected = false
        
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
}

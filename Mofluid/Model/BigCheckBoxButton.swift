//
//  BigCheckBoxButton.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class BigCheckBoxButton : FlipFlopButton{
    fileprivate let selectBigCheckboxImage = UIImage(named: "Logincheck-active")
    fileprivate let unselectBigCheckboxImage = UIImage(named: "Logincheck-normal")
    
    init(){
        super.init(frame : CGRect.zero)
        
        self.selectedImage = selectBigCheckboxImage
        self.unselectedImage = unselectBigCheckboxImage
        
        self.isSelected = false
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
}

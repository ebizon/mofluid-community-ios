//
//  RadioButton.swift
//  Mofluid
//
//  Created by Ebizon-mac-2015 on 05/10/15.
//  Copyright © 2015 Mofluid. All rights reserved.
//

import UIKit
import Foundation

class RadioButton : FlipFlopButton{
    
    fileprivate let selectRadioImage = UIImage(named: "Radio-active.png")
    fileprivate let unselectRadioImage = UIImage(named: "Radio-normal.png")
    
    init(){
        super.init(frame : CGRect.zero)
        
        self.selectedImage = selectRadioImage
        self.unselectedImage = unselectRadioImage
        
        self.isSelected = false
        
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        
    }
}
